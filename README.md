# PHP Deployer and Composer for Bitbucket Pipelines

Custom image for Bitbucket Pipelines.

Based on PHP 7.4 CLI Alpine.

Features:
- Composer with prestissimo plugin
- Deployer with Recipes
- Very small size (ca. 44 MB)

This Dockerfile is automagically built on [Docker Hub](https://hub.docker.com/r/rechtlogisch/deployer)

# Usage

Enable Pipelines in `Repository settings` > `Pipelines` > `Settings`.

Add `bitbucket-pipelines.yml` to your repository.

Example:
```
image: rechtlogisch/deployer

pipelines:
  default:
    - step:
        name: Deploy production
        deployment: production
        script:
          - dep deploy production
```

Add `deploy.php` and `hosts.yml` to your repository (cf. [Deployer documentation](https://deployer.org/docs/getting-started.html))

## Known issues

### Access private repositories with your Pipeline SSH Key.

If you want to access private repositories during deployment on a remote host and don’t want to setup a private key on this remote host - you could use the Pipeline SSH Key.

For this to work the SSH Key agent has to be started inside the container and the native Pipeline SSH Key has to be forwarded using the agent.

Add the following lines to your `bitbucket-pipelines.yml` scripts before the deploy line:

```
- eval $(ssh-agent)
- ssh-add -k $(head -n 1 ~/.ssh/config | sed 's/IdentityFile //')
```

Do not forget to add the public key of your Pipeline as an Access Key of the repository you want to retrieve during deployment.
