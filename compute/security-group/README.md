This module aims to implement ALL combinations of arguments supported by AWS and latest stable version of Terraform:

IPv4/IPv6 CIDR blocks
VPC endpoint prefix lists (use data source aws_prefix_list)
Access from source security groups
Access from self
Named rules (see the rules here)
Named groups of rules with ingress (inbound) and egress (outbound) ports open for common scenarios (eg, ssh, http-80, mysql, see the whole list here)
Conditionally create security group and/or all required security group rules.
Ingress and egress rules can be configured in a variety of ways. See inputs section for all supported arguments and complete example for the complete use-case.

If there is a missing feature or a bug - open an issue.

Terraform versions
For Terraform 0.13 or later use any version from v4.5.0 of this module or newer.

For Terraform 0.12 use any version from v3.* to v4.4.0.

If you are using Terraform 0.11 you can use versions v2.*.

Usage
There are two ways to create security groups using this module:

Specifying predefined rules (HTTP, SSH, etc)
Specifying custom rules
Security group with predefined rules
module "web_server_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = "web-server"
  description = "Security group for web-server with HTTP ports open within VPC"
  vpc_id      = "vpc-12345678"

  ingress_cidr_blocks = ["10.10.0.0/16"]
}
Security group with custom rules
module "vote_service_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "user-service"
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = "vpc-12345678"

  ingress_cidr_blocks      = ["10.10.0.0/16"]
  ingress_rules            = ["https-443-tcp"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8090
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = "10.10.0.0/16"
    },
    {
      rule        = "postgresql-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}
Note about "value of 'count' cannot be computed"
Terraform 0.11 has a limitation which does not allow computed values inside count attribute on resources (issues: #16712, #18015, ...)

Computed values are values provided as outputs from module. Non-computed values are all others - static values, values referenced as variable and from data-sources.

When you need to specify computed value inside security group rule argument you need to specify it using an argument which starts with computed_ and provide a number of elements in the argument which starts with number_of_computed_. See these examples:

module "http_sg" {
  source = "terraform-aws-modules/security-group/aws"
  # omitted for brevity
}

module "db_computed_source_sg" {
  # omitted for brevity

  vpc_id = "vpc-12345678" # these are valid values also - `module.vpc.vpc_id` and `local.vpc_id`

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = module.http_sg.security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1
}

module "db_computed_sg" {
  # omitted for brevity

  ingress_cidr_blocks = ["10.10.0.0/16", data.aws_security_group.default.id]

  computed_ingress_cidr_blocks           = [module.vpc.vpc_cidr_block]
  number_of_computed_ingress_cidr_blocks = 1
}

module "db_computed_merged_sg" {
  # omitted for brevity

  computed_ingress_cidr_blocks           = ["10.10.0.0/16", module.vpc.vpc_cidr_block]
  number_of_computed_ingress_cidr_blocks = 2
}
Note that db_computed_sg and db_computed_merged_sg are equal, because it is possible to put both computed and non-computed values in arguments starting with computed_.

Conditional creation
Sometimes you need a way to conditionally create a security group. If you're using Terraform < 0.13 which lacks module support for count, you can instead specify the argument create.

# This security group will not be created
module "vote_service_sg" {
  source = "terraform-aws-modules/security-group/aws"

  create = false
  # ... omitted
}
Examples
Complete Security Group example shows all available parameters to configure security group.
Security Group "Rules Only" example shows how to manage just rules of a security group that is created outside.
HTTP Security Group example shows more applicable security groups for common web-servers.
Disable creation of Security Group example shows how to disable creation of security group.
Dynamic values inside Security Group rules example shows how to specify values inside security group rules (data-sources and variables are allowed).
Computed values inside Security Group rules example shows how to specify computed values inside security group rules (solution for value of 'count' cannot be computed problem).
How to add/update rules/groups?
Rules and groups are defined in rules.tf. Run update_groups.sh when content of that file has changed to recreate content of all automatic modules.

Known issues
No issue is creating limit on this module.

Requirements
Name	Version
terraform	>= 1.0
aws	>= 3.29
Providers
Name	Version
aws	>= 3.29
Modules
No modules.

Resources
Name	Type
aws_security_group.this	resource
aws_security_group.this_name_prefix	resource
aws_security_group_rule.computed_egress_rules	resource
aws_security_group_rule.computed_egress_with_cidr_blocks	resource
aws_security_group_rule.computed_egress_with_ipv6_cidr_blocks	resource
aws_security_group_rule.computed_egress_with_prefix_list_ids	resource
aws_security_group_rule.computed_egress_with_self	resource
aws_security_group_rule.computed_egress_with_source_security_group_id	resource
aws_security_group_rule.computed_ingress_rules	resource
aws_security_group_rule.computed_ingress_with_cidr_blocks	resource
aws_security_group_rule.computed_ingress_with_ipv6_cidr_blocks	resource
aws_security_group_rule.computed_ingress_with_prefix_list_ids	resource
aws_security_group_rule.computed_ingress_with_self	resource
aws_security_group_rule.computed_ingress_with_source_security_group_id	resource
aws_security_group_rule.egress_rules	resource
aws_security_group_rule.egress_with_cidr_blocks	resource
aws_security_group_rule.egress_with_ipv6_cidr_blocks	resource
aws_security_group_rule.egress_with_prefix_list_ids	resource
aws_security_group_rule.egress_with_self	resource
aws_security_group_rule.egress_with_source_security_group_id	resource
aws_security_group_rule.ingress_rules	resource
aws_security_group_rule.ingress_with_cidr_blocks	resource
aws_security_group_rule.ingress_with_ipv6_cidr_blocks	resource
aws_security_group_rule.ingress_with_prefix_list_ids	resource
aws_security_group_rule.ingress_with_self	resource
aws_security_group_rule.ingress_with_source_security_group_id	resource
Inputs
Name	Description	Type	Default	Required
auto_groups	Map of groups of security group rules to use to generate modules (see update_groups.sh)	map(map(list(string)))	
{
  "activemq": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "activemq-5671-tcp",
      "activemq-8883-tcp",
      "activemq-61614-tcp",
      "activemq-61617-tcp",
      "activemq-61619-tcp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "alertmanager": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "alertmanager-9093-tcp",
      "alertmanager-9094-tcp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "carbon-relay-ng": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "carbon-line-in-tcp",
      "carbon-line-in-udp",
      "carbon-pickle-tcp",
      "carbon-pickle-udp",
      "carbon-gui-udp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "cassandra": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "cassandra-clients-tcp",
      "cassandra-thrift-clients-tcp",
      "cassandra-jmx-tcp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "consul": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "consul-tcp",
      "consul-grpc-tcp",
      "consul-grpc-tcp-tls",
      "consul-webui-http-tcp",
      "consul-webui-https-tcp",
      "consul-dns-tcp",
      "consul-dns-udp",
      "consul-serf-lan-tcp",
      "consul-serf-lan-udp",
      "consul-serf-wan-tcp",
      "consul-serf-wan-udp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "dax-cluster": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "dax-cluster-unencrypted-tcp",
      "dax-cluster-encrypted-tcp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "docker-swarm": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "docker-swarm-mngmt-tcp",
      "docker-swarm-node-tcp",
      "docker-swarm-node-udp",
      "docker-swarm-overlay-udp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "elasticsearch": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "elasticsearch-rest-tcp",
      "elasticsearch-java-tcp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "etcd": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "etcd-client-tcp",
      "etcd-peer-tcp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "grafana": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "grafana-tcp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "graphite-statsd": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "graphite-webui",
      "graphite-2003-tcp",
      "graphite-2004-tcp",
      "graphite-2023-tcp",
      "graphite-2024-tcp",
      "graphite-8080-tcp",
      "graphite-8125-tcp",
      "graphite-8125-udp",
      "graphite-8126-tcp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "http-80": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "http-80-tcp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "http-8080": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "http-8080-tcp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "https-443": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "https-443-tcp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "https-8443": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "https-8443-tcp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "ipsec-4500": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "ipsec-4500-udp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "ipsec-500": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "ipsec-500-udp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "kafka": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "kafka-broker-tcp",
      "kafka-broker-tls-tcp",
      "kafka-broker-tls-public-tcp",
      "kafka-broker-sasl-scram-tcp",
      "kafka-broker-sasl-scram-tcp",
      "kafka-broker-sasl-iam-tcp",
      "kafka-broker-sasl-iam-public-tcp",
      "kafka-jmx-exporter-tcp",
      "kafka-node-exporter-tcp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "kibana": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "kibana-tcp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "kubernetes-api": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "kubernetes-api-tcp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "ldap": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "ldap-tcp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "ldaps": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "ldaps-tcp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "logstash": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "logstash-tcp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "loki": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "loki-grafana",
      "loki-grafana-grpc"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "memcached": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "memcached-tcp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "minio": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "minio-tcp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "mongodb": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "mongodb-27017-tcp",
      "mongodb-27018-tcp",
      "mongodb-27019-tcp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "mssql": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "mssql-tcp",
      "mssql-udp",
      "mssql-analytics-tcp",
      "mssql-broker-tcp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "mysql": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "mysql-tcp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "nfs": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "nfs-tcp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "nomad": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "nomad-http-tcp",
      "nomad-rpc-tcp",
      "nomad-serf-tcp",
      "nomad-serf-udp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "ntp": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "ntp-udp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "openvpn": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "openvpn-udp",
      "openvpn-tcp",
      "openvpn-https-tcp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "oracle-db": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "oracle-db-tcp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "postgresql": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "postgresql-tcp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "prometheus": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "prometheus-http-tcp",
      "prometheus-pushgateway-http-tcp",
      "prometheus-node-exporter-http-tcp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "promtail": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "promtail-http"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "puppet": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "puppet-tcp",
      "puppetdb-tcp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "rabbitmq": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "rabbitmq-4369-tcp",
      "rabbitmq-5671-tcp",
      "rabbitmq-5672-tcp",
      "rabbitmq-15672-tcp",
      "rabbitmq-25672-tcp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "rdp": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "rdp-tcp",
      "rdp-udp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "redis": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "redis-tcp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "redshift": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "redshift-tcp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "smtp": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "smtp-tcp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "smtp-submission": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "smtp-submission-587-tcp",
      "smtp-submission-2587-tcp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "smtps": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "smtps-465-tcp",
      "smtps-2465-tcp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "solr": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "solr-tcp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "splunk": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "splunk-indexer-tcp",
      "splunk-clients-tcp",
      "splunk-splunkd-tcp",
      "splunk-hec-tcp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "squid": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "squid-proxy-tcp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "ssh": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "ssh-tcp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "storm": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "storm-nimbus-tcp",
      "storm-ui-tcp",
      "storm-supervisor-tcp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "vault": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "vault-tcp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "wazuh": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "wazuh-server-agent-connection-tcp",
      "wazuh-server-agent-connection-udp",
      "wazuh-server-agent-enrollment",
      "wazuh-server-agent-cluster-daemon",
      "wazuh-server-syslog-collector-tcp",
      "wazuh-server-syslog-collector-udp",
      "wazuh-server-restful-api",
      "wazuh-indexer-restful-api",
      "wazuh-dashboard"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "web": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "http-80-tcp",
      "http-8080-tcp",
      "https-443-tcp",
      "web-jmx-tcp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "winrm": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "winrm-http-tcp",
      "winrm-https-tcp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "zabbix": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "zabbix-server",
      "zabbix-proxy",
      "zabbix-agent"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "zipkin": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "zipkin-admin-tcp",
      "zipkin-admin-query-tcp",
      "zipkin-admin-web-tcp",
      "zipkin-query-tcp",
      "zipkin-web-tcp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  },
  "zookeeper": {
    "egress_rules": [
      "all-all"
    ],
    "ingress_rules": [
      "zookeeper-2181-tcp",
      "zookeeper-2182-tls-tcp",
      "zookeeper-2888-tcp",
      "zookeeper-3888-tcp",
      "zookeeper-jmx-tcp"
    ],
    "ingress_with_self": [
      "all-all"
    ]
  }
}
no
computed_egress_rules	List of computed egress rules to create by name	list(string)	[]	no
computed_egress_with_cidr_blocks	List of computed egress rules to create where 'cidr_blocks' is used	list(map(string))	[]	no
computed_egress_with_ipv6_cidr_blocks	List of computed egress rules to create where 'ipv6_cidr_blocks' is used	list(map(string))	[]	no
computed_egress_with_prefix_list_ids	List of computed egress rules to create where 'prefix_list_ids' is used only	list(map(string))	[]	no
computed_egress_with_self	List of computed egress rules to create where 'self' is defined	list(map(string))	[]	no
computed_egress_with_source_security_group_id	List of computed egress rules to create where 'source_security_group_id' is used	list(map(string))	[]	no
computed_ingress_rules	List of computed ingress rules to create by name	list(string)	[]	no
computed_ingress_with_cidr_blocks	List of computed ingress rules to create where 'cidr_blocks' is used	list(map(string))	[]	no
computed_ingress_with_ipv6_cidr_blocks	List of computed ingress rules to create where 'ipv6_cidr_blocks' is used	list(map(string))	[]	no
computed_ingress_with_prefix_list_ids	List of computed ingress rules to create where 'prefix_list_ids' is used	list(map(string))	[]	no
computed_ingress_with_self	List of computed ingress rules to create where 'self' is defined	list(map(string))	[]	no
computed_ingress_with_source_security_group_id	List of computed ingress rules to create where 'source_security_group_id' is used	list(map(string))	[]	no
create	Whether to create security group and all rules	bool	true	no
create_sg	Whether to create security group	bool	true	no
create_timeout	Time to wait for a security group to be created	string	"10m"	no
delete_timeout	Time to wait for a security group to be deleted	string	"15m"	no
description	Description of security group	string	"Security Group managed by Terraform"	no
egress_cidr_blocks	List of IPv4 CIDR ranges to use on all egress rules	list(string)	
[
  "0.0.0.0/0"
]
no
egress_ipv6_cidr_blocks	List of IPv6 CIDR ranges to use on all egress rules	list(string)	
[
  "::/0"
]
no
egress_prefix_list_ids	List of prefix list IDs (for allowing access to VPC endpoints) to use on all egress rules	list(string)	[]	no
egress_rules	List of egress rules to create by name	list(string)	[]	no
egress_with_cidr_blocks	List of egress rules to create where 'cidr_blocks' is used	list(map(string))	[]	no
egress_with_ipv6_cidr_blocks	List of egress rules to create where 'ipv6_cidr_blocks' is used	list(map(string))	[]	no
egress_with_prefix_list_ids	List of egress rules to create where 'prefix_list_ids' is used only	list(map(string))	[]	no
egress_with_self	List of egress rules to create where 'self' is defined	list(map(string))	[]	no
egress_with_source_security_group_id	List of egress rules to create where 'source_security_group_id' is used	list(map(string))	[]	no
ingress_cidr_blocks	List of IPv4 CIDR ranges to use on all ingress rules	list(string)	[]	no
ingress_ipv6_cidr_blocks	List of IPv6 CIDR ranges to use on all ingress rules	list(string)	[]	no
ingress_prefix_list_ids	List of prefix list IDs (for allowing access to VPC endpoints) to use on all ingress rules	list(string)	[]	no
ingress_rules	List of ingress rules to create by name	list(string)	[]	no
ingress_with_cidr_blocks	List of ingress rules to create where 'cidr_blocks' is used	list(map(string))	[]	no
ingress_with_ipv6_cidr_blocks	List of ingress rules to create where 'ipv6_cidr_blocks' is used	list(map(string))	[]	no
ingress_with_prefix_list_ids	List of ingress rules to create where 'prefix_list_ids' is used only	list(map(string))	[]	no
ingress_with_self	List of ingress rules to create where 'self' is defined	list(map(string))	[]	no
ingress_with_source_security_group_id	List of ingress rules to create where 'source_security_group_id' is used	list(map(string))	[]	no
name	Name of security group - not required if create_sg is false	string	null	no
number_of_computed_egress_rules	Number of computed egress rules to create by name	number	0	no
number_of_computed_egress_with_cidr_blocks	Number of computed egress rules to create where 'cidr_blocks' is used	number	0	no
number_of_computed_egress_with_ipv6_cidr_blocks	Number of computed egress rules to create where 'ipv6_cidr_blocks' is used	number	0	no
number_of_computed_egress_with_prefix_list_ids	Number of computed egress rules to create where 'prefix_list_ids' is used only	number	0	no
number_of_computed_egress_with_self	Number of computed egress rules to create where 'self' is defined	number	0	no
number_of_computed_egress_with_source_security_group_id	Number of computed egress rules to create where 'source_security_group_id' is used	number	0	no
number_of_computed_ingress_rules	Number of computed ingress rules to create by name	number	0	no
number_of_computed_ingress_with_cidr_blocks	Number of computed ingress rules to create where 'cidr_blocks' is used	number	0	no
number_of_computed_ingress_with_ipv6_cidr_blocks	Number of computed ingress rules to create where 'ipv6_cidr_blocks' is used	number	0	no
number_of_computed_ingress_with_prefix_list_ids	Number of computed ingress rules to create where 'prefix_list_ids' is used	number	0	no
number_of_computed_ingress_with_self	Number of computed ingress rules to create where 'self' is defined	number	0	no
number_of_computed_ingress_with_source_security_group_id	Number of computed ingress rules to create where 'source_security_group_id' is used	number	0	no
putin_khuylo	Do you agree that Putin doesn't respect Ukrainian sovereignty and territorial integrity? More info: https://en.wikipedia.org/wiki/Putin_khuylo!	bool	true	no
revoke_rules_on_delete	Instruct Terraform to revoke all of the Security Groups attached ingress and egress rules before deleting the rule itself. Enable for EMR.	bool	false	no
rules	Map of known security group rules (define as 'name' = ['from port', 'to port', 'protocol', 'description'])	map(list(any))	
{
  "_": [
    "",
    "",
    ""
  ],
  "activemq-5671-tcp": [
    5671,
    5671,
    "tcp",
    "ActiveMQ AMQP"
  ],
  "activemq-61614-tcp": [
    61614,
    61614,
    "tcp",
    "ActiveMQ STOMP"
  ],
  "activemq-61617-tcp": [
    61617,
    61617,
    "tcp",
    "ActiveMQ OpenWire"
  ],
  "activemq-61619-tcp": [
    61619,
    61619,
    "tcp",
    "ActiveMQ WebSocket"
  ],
  "activemq-8883-tcp": [
    8883,
    8883,
    "tcp",
    "ActiveMQ MQTT"
  ],
  "alertmanager-9093-tcp": [
    9093,
    9093,
    "tcp",
    "Alert Manager"
  ],
  "alertmanager-9094-tcp": [
    9094,
    9094,
    "tcp",
    "Alert Manager Cluster"
  ],
  "all-all": [
    -1,
    -1,
    "-1",
    "All protocols"
  ],
  "all-icmp": [
    -1,
    -1,
    "icmp",
    "All IPV4 ICMP"
  ],
  "all-ipv6-icmp": [
    -1,
    -1,
    58,
    "All IPV6 ICMP"
  ],
  "all-tcp": [
    0,
    65535,
    "tcp",
    "All TCP ports"
  ],
  "all-udp": [
    0,
    65535,
    "udp",
    "All UDP ports"
  ],
  "carbon-admin-tcp": [
    2004,
    2004,
    "tcp",
    "Carbon admin"
  ],
  "carbon-gui-udp": [
    8081,
    8081,
    "tcp",
    "Carbon GUI"
  ],
  "carbon-line-in-tcp": [
    2003,
    2003,
    "tcp",
    "Carbon line-in"
  ],
  "carbon-line-in-udp": [
    2003,
    2003,
    "udp",
    "Carbon line-in"
  ],
  "carbon-pickle-tcp": [
    2013,
    2013,
    "tcp",
    "Carbon pickle"
  ],
  "carbon-pickle-udp": [
    2013,
    2013,
    "udp",
    "Carbon pickle"
  ],
  "cassandra-clients-tcp": [
    9042,
    9042,
    "tcp",
    "Cassandra clients"
  ],
  "cassandra-jmx-tcp": [
    7199,
    7199,
    "tcp",
    "JMX"
  ],
  "cassandra-thrift-clients-tcp": [
    9160,
    9160,
    "tcp",
    "Cassandra Thrift clients"
  ],
  "consul-dns-tcp": [
    8600,
    8600,
    "tcp",
    "Consul DNS"
  ],
  "consul-dns-udp": [
    8600,
    8600,
    "udp",
    "Consul DNS"
  ],
  "consul-grpc-tcp": [
    8502,
    8502,
    "tcp",
    "Consul gRPC"
  ],
  "consul-grpc-tcp-tls": [
    8503,
    8503,
    "tcp",
    "Consul gRPC TLS"
  ],
  "consul-serf-lan-tcp": [
    8301,
    8301,
    "tcp",
    "Serf LAN"
  ],
  "consul-serf-lan-udp": [
    8301,
    8301,
    "udp",
    "Serf LAN"
  ],
  "consul-serf-wan-tcp": [
    8302,
    8302,
    "tcp",
    "Serf WAN"
  ],
  "consul-serf-wan-udp": [
    8302,
    8302,
    "udp",
    "Serf WAN"
  ],
  "consul-tcp": [
    8300,
    8300,
    "tcp",
    "Consul server"
  ],
  "consul-webui-http-tcp": [
    8500,
    8500,
    "tcp",
    "Consul web UI HTTP"
  ],
  "consul-webui-https-tcp": [
    8501,
    8501,
    "tcp",
    "Consul web UI HTTPS"
  ],
  "dax-cluster-encrypted-tcp": [
    9111,
    9111,
    "tcp",
    "DAX Cluster encrypted"
  ],
  "dax-cluster-unencrypted-tcp": [
    8111,
    8111,
    "tcp",
    "DAX Cluster unencrypted"
  ],
  "dns-tcp": [
    53,
    53,
    "tcp",
    "DNS"
  ],
  "dns-udp": [
    53,
    53,
    "udp",
    "DNS"
  ],
  "docker-swarm-mngmt-tcp": [
    2377,
    2377,
    "tcp",
    "Docker Swarm cluster management"
  ],
  "docker-swarm-node-tcp": [
    7946,
    7946,
    "tcp",
    "Docker Swarm node"
  ],
  "docker-swarm-node-udp": [
    7946,
    7946,
    "udp",
    "Docker Swarm node"
  ],
  "docker-swarm-overlay-udp": [
    4789,
    4789,
    "udp",
    "Docker Swarm Overlay Network Traffic"
  ],
  "elasticsearch-java-tcp": [
    9300,
    9300,
    "tcp",
    "Elasticsearch Java interface"
  ],
  "elasticsearch-rest-tcp": [
    9200,
    9200,
    "tcp",
    "Elasticsearch REST interface"
  ],
  "etcd-client-tcp": [
    2379,
    2379,
    "tcp",
    "Etcd Client"
  ],
  "etcd-peer-tcp": [
    2380,
    2380,
    "tcp",
    "Etcd Peer"
  ],
  "grafana-tcp": [
    3000,
    3000,
    "tcp",
    "Grafana Dashboard"
  ],
  "graphite-2003-tcp": [
    2003,
    2003,
    "tcp",
    "Carbon receiver plain text"
  ],
  "graphite-2004-tcp": [
    2004,
    2004,
    "tcp",
    "Carbon receiver pickle"
  ],
  "graphite-2023-tcp": [
    2023,
    2023,
    "tcp",
    "Carbon aggregator plaintext"
  ],
  "graphite-2024-tcp": [
    2024,
    2024,
    "tcp",
    "Carbon aggregator pickle"
  ],
  "graphite-8080-tcp": [
    8080,
    8080,
    "tcp",
    "Graphite gunicorn port"
  ],
  "graphite-8125-tcp": [
    8125,
    8125,
    "tcp",
    "Statsd TCP"
  ],
  "graphite-8125-udp": [
    8125,
    8125,
    "udp",
    "Statsd UDP default"
  ],
  "graphite-8126-tcp": [
    8126,
    8126,
    "tcp",
    "Statsd admin"
  ],
  "graphite-webui": [
    80,
    80,
    "tcp",
    "Graphite admin interface"
  ],
  "http-80-tcp": [
    80,
    80,
    "tcp",
    "HTTP"
  ],
  "http-8080-tcp": [
    8080,
    8080,
    "tcp",
    "HTTP"
  ],
  "https-443-tcp": [
    443,
    443,
    "tcp",
    "HTTPS"
  ],
  "https-8443-tcp": [
    8443,
    8443,
    "tcp",
    "HTTPS"
  ],
  "ipsec-4500-udp": [
    4500,
    4500,
    "udp",
    "IPSEC NAT-T"
  ],
  "ipsec-500-udp": [
    500,
    500,
    "udp",
    "IPSEC ISAKMP"
  ],
  "kafka-broker-sasl-iam-public-tcp": [
    9198,
    9198,
    "tcp",
    "Kafka SASL/IAM Public access control enabled (MSK specific)"
  ],
  "kafka-broker-sasl-iam-tcp": [
    9098,
    9098,
    "tcp",
    "Kafka SASL/IAM access control enabled (MSK specific)"
  ],
  "kafka-broker-sasl-scram-public-tcp": [
    9196,
    9196,
    "tcp",
    "Kafka SASL/SCRAM Public enabled broker (MSK specific)"
  ],
  "kafka-broker-sasl-scram-tcp": [
    9096,
    9096,
    "tcp",
    "Kafka SASL/SCRAM enabled broker (MSK specific)"
  ],
  "kafka-broker-tcp": [
    9092,
    9092,
    "tcp",
    "Kafka PLAINTEXT enable broker 0.8.2+"
  ],
  "kafka-broker-tls-public-tcp": [
    9194,
    9194,
    "tcp",
    "Kafka TLS Public enabled broker 0.8.2+ (MSK specific)"
  ],
  "kafka-broker-tls-tcp": [
    9094,
    9094,
    "tcp",
    "Kafka TLS enabled broker 0.8.2+"
  ],
  "kafka-jmx-exporter-tcp": [
    11001,
    11001,
    "tcp",
    "Kafka JMX Exporter"
  ],
  "kafka-node-exporter-tcp": [
    11002,
    11002,
    "tcp",
    "Kafka Node Exporter"
  ],
  "kibana-tcp": [
    5601,
    5601,
    "tcp",
    "Kibana Web Interface"
  ],
  "kubernetes-api-tcp": [
    6443,
    6443,
    "tcp",
    "Kubernetes API Server"
  ],
  "ldap-tcp": [
    389,
    389,
    "tcp",
    "LDAP"
  ],
  "ldaps-tcp": [
    636,
    636,
    "tcp",
    "LDAPS"
  ],
  "logstash-tcp": [
    5044,
    5044,
    "tcp",
    "Logstash"
  ],
  "loki-grafana": [
    3100,
    3100,
    "tcp",
    "Grafana Loki endpoint"
  ],
  "loki-grafana-grpc": [
    9095,
    9095,
    "tcp",
    "Grafana Loki GRPC"
  ],
  "memcached-tcp": [
    11211,
    11211,
    "tcp",
    "Memcached"
  ],
  "minio-tcp": [
    9000,
    9000,
    "tcp",
    "MinIO"
  ],
  "mongodb-27017-tcp": [
    27017,
    27017,
    "tcp",
    "MongoDB"
  ],
  "mongodb-27018-tcp": [
    27018,
    27018,
    "tcp",
    "MongoDB shard"
  ],
  "mongodb-27019-tcp": [
    27019,
    27019,
    "tcp",
    "MongoDB config server"
  ],
  "mssql-analytics-tcp": [
    2383,
    2383,
    "tcp",
    "MSSQL Analytics"
  ],
  "mssql-broker-tcp": [
    4022,
    4022,
    "tcp",
    "MSSQL Broker"
  ],
  "mssql-tcp": [
    1433,
    1433,
    "tcp",
    "MSSQL Server"
  ],
  "mssql-udp": [
    1434,
    1434,
    "udp",
    "MSSQL Browser"
  ],
  "mysql-tcp": [
    3306,
    3306,
    "tcp",
    "MySQL/Aurora"
  ],
  "nfs-tcp": [
    2049,
    2049,
    "tcp",
    "NFS/EFS"
  ],
  "nomad-http-tcp": [
    4646,
    4646,
    "tcp",
    "Nomad HTTP"
  ],
  "nomad-rpc-tcp": [
    4647,
    4647,
    "tcp",
    "Nomad RPC"
  ],
  "nomad-serf-tcp": [
    4648,
    4648,
    "tcp",
    "Serf"
  ],
  "nomad-serf-udp": [
    4648,
    4648,
    "udp",
    "Serf"
  ],
  "ntp-udp": [
    123,
    123,
    "udp",
    "NTP"
  ],
  "octopus-tentacle-tcp": [
    10933,
    10933,
    "tcp",
    "Octopus Tentacle"
  ],
  "openvpn-https-tcp": [
    443,
    443,
    "tcp",
    "OpenVPN"
  ],
  "openvpn-tcp": [
    943,
    943,
    "tcp",
    "OpenVPN"
  ],
  "openvpn-udp": [
    1194,
    1194,
    "udp",
    "OpenVPN"
  ],
  "oracle-db-tcp": [
    1521,
    1521,
    "tcp",
    "Oracle"
  ],
  "postgresql-tcp": [
    5432,
    5432,
    "tcp",
    "PostgreSQL"
  ],
  "prometheus-http-tcp": [
    9090,
    9090,
    "tcp",
    "Prometheus"
  ],
  "prometheus-node-exporter-http-tcp": [
    9100,
    9100,
    "tcp",
    "Prometheus Node Exporter"
  ],
  "prometheus-pushgateway-http-tcp": [
    9091,
    9091,
    "tcp",
    "Prometheus Pushgateway"
  ],
  "promtail-http": [
    9080,
    9080,
    "tcp",
    "Promtail endpoint"
  ],
  "puppet-tcp": [
    8140,
    8140,
    "tcp",
    "Puppet"
  ],
  "puppetdb-tcp": [
    8081,
    8081,
    "tcp",
    "PuppetDB"
  ],
  "rabbitmq-15672-tcp": [
    15672,
    15672,
    "tcp",
    "RabbitMQ"
  ],
  "rabbitmq-25672-tcp": [
    25672,
    25672,
    "tcp",
    "RabbitMQ"
  ],
  "rabbitmq-4369-tcp": [
    4369,
    4369,
    "tcp",
    "RabbitMQ epmd"
  ],
  "rabbitmq-5671-tcp": [
    5671,
    5671,
    "tcp",
    "RabbitMQ"
  ],
  "rabbitmq-5672-tcp": [
    5672,
    5672,
    "tcp",
    "RabbitMQ"
  ],
  "rdp-tcp": [
    3389,
    3389,
    "tcp",
    "Remote Desktop"
  ],
  "rdp-udp": [
    3389,
    3389,
    "udp",
    "Remote Desktop"
  ],
  "redis-tcp": [
    6379,
    6379,
    "tcp",
    "Redis"
  ],
  "redshift-tcp": [
    5439,
    5439,
    "tcp",
    "Redshift"
  ],
  "saltstack-tcp": [
    4505,
    4506,
    "tcp",
    "SaltStack"
  ],
  "smtp-submission-2587-tcp": [
    2587,
    2587,
    "tcp",
    "SMTP Submission"
  ],
  "smtp-submission-587-tcp": [
    587,
    587,
    "tcp",
    "SMTP Submission"
  ],
  "smtp-tcp": [
    25,
    25,
    "tcp",
    "SMTP"
  ],
  "smtps-2456-tcp": [
    2465,
    2465,
    "tcp",
    "SMTPS"
  ],
  "smtps-465-tcp": [
    465,
    465,
    "tcp",
    "SMTPS"
  ],
  "solr-tcp": [
    8983,
    8987,
    "tcp",
    "Solr"
  ],
  "splunk-hec-tcp": [
    8088,
    8088,
    "tcp",
    "Splunk HEC"
  ],
  "splunk-indexer-tcp": [
    9997,
    9997,
    "tcp",
    "Splunk indexer"
  ],
  "splunk-splunkd-tcp": [
    8089,
    8089,
    "tcp",
    "Splunkd"
  ],
  "splunk-web-tcp": [
    8000,
    8000,
    "tcp",
    "Splunk Web"
  ],
  "squid-proxy-tcp": [
    3128,
    3128,
    "tcp",
    "Squid default proxy"
  ],
  "ssh-tcp": [
    22,
    22,
    "tcp",
    "SSH"
  ],
  "storm-nimbus-tcp": [
    6627,
    6627,
    "tcp",
    "Nimbus"
  ],
  "storm-supervisor-tcp": [
    6700,
    6703,
    "tcp",
    "Supervisor"
  ],
  "storm-ui-tcp": [
    8080,
    8080,
    "tcp",
    "Storm UI"
  ],
  "vault-tcp": [
    8200,
    8200,
    "tcp",
    "Vault"
  ],
  "wazuh-dashboard": [
    443,
    443,
    "tcp",
    "Wazuh web user interface"
  ],
  "wazuh-indexer-restful-api": [
    9200,
    9200,
    "tcp",
    "Wazuh indexer RESTful API"
  ],
  "wazuh-server-agent-cluster-daemon": [
    1516,
    1516,
    "tcp",
    "Wazuh cluster daemon"
  ],
  "wazuh-server-agent-connection-tcp": [
    1514,
    1514,
    "tcp",
    "Agent connection service(TCP)"
  ],
  "wazuh-server-agent-connection-udp": [
    1514,
    1514,
    "udp",
    "Agent connection service(UDP)"
  ],
  "wazuh-server-agent-enrollment": [
    1515,
    1515,
    "tcp",
    "Agent enrollment service"
  ],
  "wazuh-server-restful-api": [
    55000,
    55000,
    "tcp",
    "Wazuh server RESTful API"
  ],
  "wazuh-server-syslog-collector-tcp": [
    514,
    514,
    "tcp",
    "Wazuh Syslog collector(TCP)"
  ],
  "wazuh-server-syslog-collector-udp": [
    514,
    514,
    "udp",
    "Wazuh Syslog collector(UDP)"
  ],
  "web-jmx-tcp": [
    1099,
    1099,
    "tcp",
    "JMX"
  ],
  "winrm-http-tcp": [
    5985,
    5985,
    "tcp",
    "WinRM HTTP"
  ],
  "winrm-https-tcp": [
    5986,
    5986,
    "tcp",
    "WinRM HTTPS"
  ],
  "zabbix-agent": [
    10050,
    10050,
    "tcp",
    "Zabbix Agent"
  ],
  "zabbix-proxy": [
    10051,
    10051,
    "tcp",
    "Zabbix Proxy"
  ],
  "zabbix-server": [
    10051,
    10051,
    "tcp",
    "Zabbix Server"
  ],
  "zipkin-admin-query-tcp": [
    9901,
    9901,
    "tcp",
    "Zipkin Admin port query"
  ],
  "zipkin-admin-tcp": [
    9990,
    9990,
    "tcp",
    "Zipkin Admin port collector"
  ],
  "zipkin-admin-web-tcp": [
    9991,
    9991,
    "tcp",
    "Zipkin Admin port web"
  ],
  "zipkin-query-tcp": [
    9411,
    9411,
    "tcp",
    "Zipkin query port"
  ],
  "zipkin-web-tcp": [
    8080,
    8080,
    "tcp",
    "Zipkin web port"
  ],
  "zookeeper-2181-tcp": [
    2181,
    2181,
    "tcp",
    "Zookeeper"
  ],
  "zookeeper-2182-tls-tcp": [
    2182,
    2182,
    "tcp",
    "Zookeeper TLS (MSK specific)"
  ],
  "zookeeper-2888-tcp": [
    2888,
    2888,
    "tcp",
    "Zookeeper"
  ],
  "zookeeper-3888-tcp": [
    3888,
    3888,
    "tcp",
    "Zookeeper"
  ],
  "zookeeper-jmx-tcp": [
    7199,
    7199,
    "tcp",
    "JMX"
  ]
}
no
security_group_id	ID of existing security group whose rules we will manage	string	null	no
tags	A mapping of tags to assign to security group	map(string)	{}	no
use_name_prefix	Whether to use name_prefix or fixed name. Should be true to able to update security group name after initial creation	bool	true	no
vpc_id	ID of the VPC where to create security group	string	null	no
Outputs
Name	Description
security_group_arn	The ARN of the security group
security_group_description	The description of the security group
security_group_id	The ID of the security group
security_group_name	The name of the security group
security_group_owner_id	The owner ID
security_group_vpc_id	The VPC ID
Authors
Module managed by Anton Babenko.

License
Apache 2 Licensed. See LICENSE for full details.