locals {
  len_subnets   = 8
  count_subnets = 3

/*
5 Maquinas Virtuais - Web Publica: 
  Ubuntu 22.04
  Storage gp3 - 20GB
  SG Web
  Subnet Publica
  Com os seguintes pacotes instalados:
    httpd
*/

  web_instances = {
    count          = 5
    ami_id         = data.aws_ami.ubuntu.image_id
    disk_size      = 20
    instance_type  = "t3.micro"
    sg_ids         = [aws_security_group.main["web_instances"].id]
    public_subnet  = true
    user_data      = join("\n", [
      "#!/bin/bash",
      "sudo apt update -y",
      "sudo apt install apache2 -y",
      "sudo ufw allow 'Apache'",
    ])
  }

/*
5 Maquinas Virtuais - Web Backend: 
  Amazon Linux
  Storage gp3 
    Dev - 10GB
    Hom - 20GB
    Prd - 50GB
  SG Web
  Subnet Privada
  Com os seguintes pacotes instalados:
    nginx
    mysql-client
*/

  backend_instances = {
    count     = 5
    ami_id    = data.aws_ami.linux2.image_id
    disk_size = {
      dev = 10
      hom = 20
      prd = 50
    }[terraform.workspace]

    instance_type = "t3.micro"
    sg_ids        = [aws_security_group.main["web_instances"].id]
    public_subnet = false
    user_data     = join("\n", [
      "#!/bin/bash",
      "sudo yum update -y",
      "sudo amazon-linux-extras enable nginx1",
      "sudo yum clean metadata",
      "sudo yum -y install nginx",
      "sudo yum install mysql -y",
      "sudo systemctl start nginx.service"
    ])
  }

/*
Banco de Dados:
    1 Instancia de Banco de Dados RDS MySQL
        Versão 8
        Multi-AZ (Apenas em caso de ambiente produtivo)
        Storage gp3 
            Dev - 20GB
            Hom - 30GB
            Prd - 50GB
        Storage Autoscaling (Apenas em caso de ambiente produtivo)
        SG Banco de Dados

    1 Instancia de Replica de Leitura (Apenas para ambiente Produtivo)

*/
  rds = {
    disk_size = {
      dev = 20
      hom = 30
      prd = 50
    }[terraform.workspace]

    autoscaling_storage = terraform.workspace == "prd"
    multi_az            = terraform.workspace == "prd"
  }

  tags = {
    Tribe   = "mackenzie"
    Team    = "devops"
    Project = var.project
  }
}
