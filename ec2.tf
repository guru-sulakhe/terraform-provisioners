resource "aws_instance" "db" {
  ami = "ami-041e2ea9402c46c32"
  vpc_security_group_ids = ["sg-0ae3a12e7b7696e53"]
  instance_type = "t2.micro"
#provisioners will run when you are creating resources
# they will not run after the resources are created
provisioner "local-exec" {
    command = "echo The server's IP address is ${self.private_ip} > private_ips.txt" # self is aws_instance.web ,this will store private IPV4 address in private_ips.txt file 
  }

#provisioner "local-exec" {
    #command = "ansible-playbook -i private_ips.txt web.yaml" # self is aws_instance.web , private_ips.txt file is created
 # }

connection { # it is used to connect to ec2 server
type     = "ssh"
user     = "ec2-user"
password = "DevOps321"
host     = self.public_ip
}

provisioner "remote-exec" { 
    inline = [ # following commands are executed in ec2 server, during $terraform apply -auto-approve command
        "sudo dnf install ansible -y",
        "sudo dnf install nginx -y",
        "sudo systemctl start nginx"
    ]
} 
}

# here privisoner is used to query the private ip address from aws_instance.web and storing it on private_ips.txt
# provisioners are used when you are creating resources
# provisioners will run, once resources are created
# it will display privisioners error, so try to run it on linux server and install terraform,ansible in it.