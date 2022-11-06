# Connect to the stage Database for QA engineers

## This document explain the way how to connect to the Staging database. 

### Right now we have the following staging databases (Before starting this document, we must ask credentials from DevOps team to connect one of them)

- company-staging-services `10.70.92.13`
- replicated-services `10.50.12.12`
- staging-shared `10.30.40.10`

#### After getting credentials one of the databases we must generate SSH key to connect remote DB server. Please execute the following command to do this. The following command will generate key pairs under `$HOME/.ssh/` folder with the style `namesurname` (please don't forget change variable `namesurname` value to your name and surname). `$HOME/.ssh/${namesurname}_id_rsa` private key will be used to authenticate to the Remote SSH server. `$HOME/.ssh/${namesurname}_id_rsa.pub` public key will be used to match ourselves in the Remote SSH server. `-C` option defines description for each of user and at the same time this description with style `namesurname` will be used as `username` in the remote SSH server. That is why we must define exactly style as `namesurname`

```bash
$ namesurname='jamalshahverdiyev'; ssh-keygen -t rsa -C "${namesurname}" -f $HOME/.ssh/${namesurname}_id_rsa -q -N ""
```

#### After generating key pairs we must add content of `$HOME/.ssh/${namesurname}_id_rsa.pub` file to repository where CI will be triggered when `Pull Request` will be approved by devops team and merged to `master` branch. This is the way how we automate user creation and uploading SSH public keys to remote SSH server for each user to the home path like as `~/.ssh/authorized_keys` 

#### The following lines clones repo and checkout to branch with variable `namesurname`. Please paste content of `$HOME/.ssh/${namesurname}_id_rsa.pub` file to the `GCloud/sshUsers/templates/stage.txt` file inside `gcp-bash-codes` repo and then push it to remote branch `namesurname` and then open `Pull request` from this branch to `master`
 
```bash
$ repo='gcp-bash-codes'; git clone https://github.com/company/${repo}.git; cd ${repo}; git checkout -b ${namesurname}; cat $HOME/.ssh/${namesurname}_id_rsa.pub >> GCloud/sshUsers/templates/stage.txt
$ git add GCloud/sshUsers/templates/stage.txt && git commit -m "Add ${namesurname} public key" && git push origin ${namesurname}
```

#### When it will be approved trigger calls `CircleCI job` which will create user and upload key for you

## Configure some DB client to staging

#### In my case I am using [`DBeaver`](https://dbeaver.io/download/) to connect to the database. It supports Mac/Linux and Windows. We must configure `DBeaver` to connect to the staging database via our SSH server which we already created SSH username and uploaded Public key to this server. The Public IP address of the SSH server you must to know, username will be used value of `namesurname` variable and private key `$HOME/.ssh/${namesurname}_id_rsa` file. Of coursee need some DB IP and credentials from devops team too

#### After installation of `DBeaver` open application for new PostgreSQL connection settings then switch to `SSH` tab to configure it



