data "vault_generic_secret" "secret" {
  path = var.password_vault_path
}

locals {
  vault_password = data.vault_generic_secret.secret.data.value
}

resource "null_resource" "create-rabbitmq" {
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOT
set -e

export AWS_SHARED_CREDENTIALS_FILE=${var.aws_shared_credentials_file}
aws configure set region ${var.aws_region} --profile ${var.aws_profile}

echo "[profile ec2]
role_arn = ${var.arn_role}
source_profile = ec2" > config.null_resource

export AWS_CONFIG_FILE=$(pwd)/config.null_resource
export AWS_DEFAULT_REGION=${var.aws_region}

aws mq create-broker --profile ${var.aws_profile} --region ${var.aws_region} --broker-name ${var.broker_name} --deployment-mode ${var.deployment_mode} --engine-type rabbitmq --engine-version ${var.engine_version} --host-instance-type ${var.type} --no-publicly-accessible --no-auto-minor-version-upgrade --maintenance-window-start-time DayOfWeek=${var.m_day},TimeOfDay=${var.m_time},TimeZone=${var.m_timezone} --security-groups ${var.security_group} --subnet-ids ${var.subnet_id} ${var.subnet_id_secondary} --logs General=true --users ConsoleAccess=true,Username=${var.rabbitmq_username},Password="$RABBIT_PASS",Groups=admin
    rm config.null_resource
    
EOT

    environment = {
      RABBIT_PASS = local.vault_password
    }
  }

}
