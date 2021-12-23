package main

import (
	"bufio"
	"context"
	"flag"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	v1 "k8s.io/client-go/kubernetes/typed/core/v1"
	"k8s.io/client-go/tools/clientcmd"
	"k8s.io/client-go/util/homedir"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
)

// Enter sudo password
func enter_sudo_password() {
	err := exec.Command("sudo", "ls")
	if err != nil {
		panic("sudo failed")
	}
}

func dnsmasq_ip(file string, domain string, svc_ip string) {
	err := os.WriteFile("/usr/local/etc/dnsmasq.d/"+file,
		[]byte("address=/"+domain+"/"+svc_ip), 0666)
	if err != nil {
		log.Fatal("Cannot save dnsmasq configuration file")
	}
}

type Bind9 struct {
	f *os.File
}

func (bind *Bind9) open() {
	var err error
	bind.f, err = os.OpenFile("/usr/local/etc/bind/zones/db.worldl.xpt", os.O_APPEND|os.O_RDWR, 0644)
	if err != nil {
		log.Fatal(err)
	}
}

func (bind *Bind9) close() {
	bind.f.Close()
}

func (bind *Bind9) find_bind_zone(key string) bool {
	scanner := bufio.NewScanner(bind.f)
	r, err := regexp.Compile(key)
	if err != nil {
		log.Fatal(err)
	}

	for scanner.Scan() {
		if r.MatchString(scanner.Text()) {
			return true
		}
	}

	return false
}

func (bind *Bind9) update_zeppelin(ip string) {
	bind.open()
	defer bind.close()
	found := bind.find_bind_zone("\\$INCLUDE /usr/local/etc/bind/zones/zeppelin.worldl.xpt")
	if !found {
		if _, err := bind.f.WriteString("$INCLUDE /usr/local/etc/bind/zones/zeppelin.worldl.xpt\n"); err != nil {
			log.Fatal(err)
		}
	}

	f, err := os.OpenFile("/usr/local/etc/bind/zones/zeppelin.worldl.xpt", os.O_WRONLY|os.O_CREATE, 0644)
	if err != nil {
		log.Fatal(err)
	}
	f.WriteString("*.zeppelin.worldl.xpt. IN A " + ip + "\n")
	f.WriteString("zeppelin.worldl.xpt. IN A " + ip + "\n")
	f.Close()
}

func (bind *Bind9) update_k8s_ingress(ip string) {
	bind.open()
	defer bind.close()
	found := bind.find_bind_zone("\\$INCLUDE /usr/local/etc/bind/zones/ingress-k8s.worldl.xpt")
	if !found {
		if _, err := bind.f.WriteString("$INCLUDE /usr/local/etc/bind/zones/ingress-k8s.worldl.xpt\n"); err != nil {
			log.Fatal(err)
		}
	}

	f, err := os.OpenFile("/usr/local/etc/bind/zones/ingress-k8s.worldl.xpt", os.O_WRONLY|os.O_CREATE, 0644)
	if err != nil {
		log.Fatal(err)
	}
	f.WriteString("*.worldl.xpt. IN A " + ip + "\n")
	f.Close()
}

type k8s struct {
	core v1.CoreV1Interface
}

func (k *k8s) kubecfg() {
	var kubeconfig *string

	if home := homedir.HomeDir(); home != "" {
		kubeconfig = flag.String("kubeconfig", filepath.Join(home, ".kube", "config"),
			"(optional) absolute path to the kubeconfig file")
	} else {
		kubeconfig = flag.String("kubeconfig", "", "absolute path to the kubeconfig file")
	}
	flag.Parse()

	config, err := clientcmd.BuildConfigFromFlags("", *kubeconfig)
	if err != nil {
		panic(err)
	}

	clientset, err := kubernetes.NewForConfig(config)
	if err != nil {
		panic(err)
	}

	k.core = clientset.CoreV1()
}

func (k *k8s) getNodeIngress() string {
	pod := k.core.Pods("ingress-nginx")
	opts := metav1.ListOptions{
		LabelSelector: "app.kubernetes.io/name=ingress-nginx",
	}

	p, err := pod.List(context.TODO(), opts)
	if err != nil {
		log.Fatal(err)
	}
	return p.Items[0].Spec.NodeName
}

func (k *k8s) getIngressIp() string {
	node := k.getNodeIngress()

	n, err := k.core.Nodes().Get(context.TODO(), node, metav1.GetOptions{})
	if err != nil {
		log.Fatal(err)
	}

	ip := n.Status.Addresses[0].Address

	return ip
}

func (k *k8s) getIngressZeppelin() string {
	svc, err := k.core.Services("zeppelin").Get(context.TODO(), "zeppelin-server",
		metav1.GetOptions{})

	if err != nil {
		log.Fatal(err)
	}

	return svc.Spec.ClusterIP
}

func main() {

	k := &k8s{}

	k.kubecfg()
	ipIngressMinikube := k.getIngressIp()
	log.Println("Minikube ingress ip:", ipIngressMinikube)
	ipIngressZeppelin := k.getIngressZeppelin()
	log.Println("Zeppelin ingress ip:", ipIngressZeppelin)

	b := Bind9{}
	b.update_zeppelin(ipIngressZeppelin)
	b.update_k8s_ingress(ipIngressMinikube)

	log.Println("Restarting BIND...")
	_, err := exec.Command("sudo", "brew", "services", "restart", "bind").Output()
	//log.Println(string(out))
	if err != nil {
		log.Fatal(err)
	}

	log.Println("Flushing host DNS cache...")
	_, err = exec.Command("dscacheutil", "-flushcache").Output()

	if err != nil {
		log.Fatal(err)
	}
}
