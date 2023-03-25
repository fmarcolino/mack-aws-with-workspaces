# mack-aws-with-workspaces
Trabalho final


## Atividade
Atividade Final - Terraform

Crie 3 Workspaces:
    - Dev
    - Hom
    - Prd

- Os recursos deverão respeitar o workspace a ser criado, cada workspace terá seu próprio state;

- Os recursos tem que ter no nome uma identificação de ambiente, exemplo:
    rds-mysql-dev
    rds-mysql-hom
    rds-mysql-prd

Crie 1 Bucket S3 com o parecido com: terraform-state-files

Criar um módulo terraform que crie de forma dinâmica:
    Network:
        1 VPC; 
        3 Subnets Privadas;
        3 Subnets Publicas;
        1 Nat Gateway;
        1 Internet Gateway;

    Security groups (Utilizar Dynamic Block):
        1 SG para maquinas Web com as portas 80 e 443 abertas;
        1 SG para bancos de dados abrindo a porta 3306 para o SG Web;

    Virtual Machines:
        5 Maquinas Virtuais - Web Publica: 
            Ubuntu 22.04
            Storage gp3 - 20GB
            SG Web
            Subnet Publica
            Com os seguintes pacotes instalados:
                httpd
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

Subir no Github e passar endereço para: william.loliveira@hotmail.com
