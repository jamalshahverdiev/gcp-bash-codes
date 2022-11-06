# Connect to the PROD Database

## This document explain the way how to connect to the Prod database

### Before starting this document, we must ask credentials from DevOps team to connect one of PRODUCTION databases

#### To connect to the PROD database we will use any `DB IDE` with SSH tunnel over SSH server. In case of PRODUCTION to get an access to the remote ssh server PUBLIC IP address, we must whitelist client PUBLIC IP address with firewall rule. To do that we must get client IP address and add to [prod.txt](https://github.com/Company/gcp-bash-codes/blob/master/GCloud/Firewall/templates/prod.txt) file (if we want to add to production white list of course). Client can get PUBLIC IP address in any terminal with this `curl ifconfig.io` command. When changes for the `prod.txt` with new IP address will be merged from `PR` (DevOps team approves this) to `master` branch circleci will be triggered to execute script with `prod` argument. CircleCI adds all new IP addresses to the Google Cloud firewall rule with name `allow-ssh-jumper` in the `company-corporate` project. This firewall rule will be applied to all instances only with specific tag  

#### After adding PUBLIC IP address to remote SSH server and getting credentials one of the databases we must generate SSH key to connect remote DB server. Please execute the following command to do this. The following command will generate key pairs under `$HOME/.ssh/` folder with the style `namesurname` (please don't forget change variable `namesurname` value to your name and surname). `$HOME/.ssh/${namesurname}_id_rsa` private key will be used to authenticate to the Remote SSH server. `$HOME/.ssh/${namesurname}_id_rsa.pub` public key will be used to match ourselves in the Remote SSH server. `-C` option defines description for each of user and at the same time this description with style `namesurname` will be used as `username` in the remote SSH server. That is why we must define exactly style as `namesurname`

```bash
$ namesurname='jamalshahverdiyev'; ssh-keygen -t rsa -C "${namesurname}" -f $HOME/.ssh/${namesurname}_id_rsa -q -N ""
```

#### After generating key pairs we must copy content of `$HOME/.ssh/${namesurname}_id_rsa.pub` file to the repository with `Pull Request`. Pull request must be approved by devops team and `Meged` to master branch. This is the way how we automate user creation and uploading SSH public keys to remote SSH server bey each user home path like as `~/.ssh/authorized_keys`

#### The following codes, clones the repository and checkout to branch with variable `namesurname`. Please paste content of `$HOME/.ssh/${namesurname}_id_rsa.pub` file to the `GCloud/sshUsers/templates/prod.txt` file inside to the repository and then push it to remote branch `namesurname` and then open `Pull request` from this branch to `master`

```bash
$ repo='gcp-bash-codes'; git clone https://github.com/Company/${repo}.git; cd ${repo}; git checkout -b ${namesurname}; cat $HOME/.ssh/${namesurname}_id_rsa.pub >> GCloud/sshUsers/templates/prod.txt
$ git add GCloud/sshUsers/templates/prod.txt && git commit -m "Add ${namesurname} public key" && git push origin ${namesurname}
```

#### When PR will be approved trigger calls `CircleCI job` which will create user and upload key for you.

## Configure some DB client to Production

#### In my case I am using [`DBeaver`](https://dbeaver.io/download/) to connect to the database. It supports Mac/Linux and Windows. We must configure `DBeaver` to connect to the production database via our SSH server which we already created SSH username and uploaded Public key to this server. We must to know the PUBLIC IP address of this SSH server. Username will be used same which, we defined as value of `namesurname` variable and private key `$HOME/.ssh/${namesurname}_id_rsa` file. Of course we need some DB IP and credentials from devops team too

#### After installation of `DBeaver` open application for new PostgreSQL connection settings then switch to `SSH` tab to configure new one. After testing connection to SSH server configure DB settings


