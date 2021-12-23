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

func kubecfg() v1.CoreV1Interface {
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

	return clientset.CoreV1()
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
		if _, err := bind.f.WriteString("$INCLUDE /usr/local/etc/bind/zones/zeppelin.worldl.xpt"); err != nil {
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

func main() {
	core := kubecfg()

	svc, err := core.Services("zeppelin").Get(context.TODO(), "zeppelin-server",
		metav1.GetOptions{})

	if err != nil {
		log.Println(err)
		log.Fatal("Cannot find service zeppelin/zepelin-server")
	}

	b := Bind9{}
	b.update_zeppelin(svc.Spec.ClusterIP)

	out, err := exec.Command("sudo", "brew", "services", "restart", "bind").Output()
	log.Println(string(out))
	if err != nil {
		log.Fatal(err)
	}

	out, err = exec.Command("dscacheutil", "-flushcache").Output()

	if err != nil {
		log.Fatal(err)
	}
}
