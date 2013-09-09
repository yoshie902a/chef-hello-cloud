# Configuration file for Chef's `knife` command
# =============================================
#
# The configuration expects you to have following pre-requisites:
#
# * Your Chef user [private key](https://community.opscode.com/users/karmi/user_key/new)
#   present in ~/.chef/USERNAME.pem
#
# * The `CHEF_ORGANIZATION` environment variable containing the Chef organization exported
#
# * The `CHEF_ORGANIZATION_KEY` environment variable containing full path to organization
#   [validation key](https://manage.opscode.com/organizations) exported
#
# * For starting instances in Amazon AWS, the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`
#   environment variables exported
#
# You can export environment variables eg. in your `~/.bashrc` or `~/.profile` files:
#
#     export CHEF_ORGANIZATION='my-organization'
#     export CHEF_ORGANIZATION_KEY='/path/to/my-organization-validator.pem'
#
# Make sure to reload the file when you change it:
#
#     source ~/.bashrc
#     source ~/.profile
#

def check_environment_variable(name, message=nil)
  unless ENV[name]
    puts "[!] You have to export the #{name} environment variable", (message || '')
    exit!(1)
  end
end

check_environment_variable 'HOME'
check_environment_variable 'USER'
check_environment_variable 'CHEF_ORGANIZATION'
check_environment_variable 'CHEF_ORGANIZATION_KEY'

current_dir = File.dirname(__FILE__)

log_level                :info
log_location             STDOUT

#node_name                ENV['USER']
node_name                ENV['CHEF_NODE_NAME']
client_key               ENV['CHEF_CLIENT_KEY']
validation_client_name   "#{ENV['CHEF_ORGANIZATION']}-validator"
validation_key           ENV['CHEF_ORGANIZATION_KEY']
chef_server_url          "https://api.opscode.com/organizations/#{ENV['CHEF_ORGANIZATION']}"
cache_options            :path => "#{current_dir}/.chef/tmp/checksums"

cookbook_path            ["#{current_dir}/site-cookbooks", "#{current_dir}/cookbooks"]

knife[:aws_access_key_id]     = ENV['AWS_ACCESS_KEY_ID']
knife[:aws_secret_access_key] = ENV['AWS_SECRET_ACCESS_KEY']
knife[:aws_ssh_key_id]        = "#{ENV['CHEF_ORGANIZATION']}-ec2"
knife[:region]                = 'us-east-1'

knife[:image]                 = 'ami-aecd60c7' # (Amazon Linux 2012.03)
#knife[:image]                 = 'ami-d0f89fb9' # (Ubuntu 12.04 LTS US-east)
knife[:ssh_user]              = 'ec2-user'
#knife[:ssh_user]              = 'ubuntu'
knife[:ssh_attribute]         = 'ec2.public_hostname'
knife[:use_sudo]              = true
knife[:ssh_identity_file]     = ENV['SSH_IDENTITY_FILE']
knife[:no_host_key_verify]    = true
knife[:bootstrap_version]     = '11.6.0'  #version needs x.y.z not just x.y
