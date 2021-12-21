package main

import (
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

func main() {
	core := kubecfg()

	svc, err := core.Services("zeppelin").Get(context.TODO(), "zeppelin-server",
		metav1.GetOptions{})

	if err != nil {
		log.Fatal("Cannot find service zeppelin/zepelin-server")
	}

	dnsmasq_ip("zeppelin.worldl.xpt.conf", ".zeppelin.worldl.xpt", svc.Spec.ClusterIP)

	out, err := exec.Command("sudo", "brew", "services", "restart", "dnsmasq").Output()
	log.Println(string(out))
	if err != nil {
		log.Fatal(err)
	}

	out, err = exec.Command("dscacheutil", "-flushcache").Output()

	if err != nil {
		log.Fatal(err)
	}
}
