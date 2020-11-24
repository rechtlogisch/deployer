# PHP with Deployer and Composer

[![Docker Cloud automated build](https://img.shields.io/docker/cloud/automated/rechtlogisch/deployer)](https://hub.docker.com/r/rechtlogisch/deployer)
[![Docker Cloud build status](https://img.shields.io/docker/cloud/build/rechtlogisch/deployer)](https://hub.docker.com/r/rechtlogisch/deployer/builds)
[![Docker image size and layers](https://images.microbadger.com/badges/image/rechtlogisch/deployer.svg)](https://hub.docker.com/r/rechtlogisch/deployer/tags)

A custom image for CI Pipelines to install dependencies, run tests and deploy code to remote servers.  

Based on the current stable PHP CLI Alpine ([cli-alpine](https://github.com/docker-library/docs/blob/master/php/README.md#supported-tags-and-respective-dockerfile-links)).

Features:
- Composer 2
- Deployer with Recipes
- Very small size

This Dockerfile is automagically built on [Docker Hub](https://hub.docker.com/r/rechtlogisch/deployer). A separately hosted script checks for a new stable PHP version at ~5am UTC every day and triggers a new build, when necessary.

# Usage

Feel free to use `rechtlogisch/deployer` with any Pipeline of your choice. You'll find usage examples in the [Wiki](../../wiki) for the following service providers:

* [Bitbucket](../../wiki/Bitbucket-Pipeline)
* [GitLab](../../wiki/GitLab-Pipeline)

## PHP modules included

* [List of PHP modules](../../wiki/List-of-PHP-modules)

## Known issues

* [Access private repositories with your Pipeline SSH Key](../../wiki/Access-private-repositories-with-your-Pipeline-SSH-Key)

## Changelog

Please see [Releases](../../releases) for more information on what has changed recently.

## Contributing

Please see [CONTRIBUTING](.github/CONTRIBUTING.md) for details.

## Security Vulnerabilities

Please review [our security policy](../../security/policy) on how to report security vulnerabilities.

## Credits

- [Krzysztof Tomasz Zembrowski](https://github.com/zembrowski)
- [All Contributors](../../contributors)

## License

The MIT License (MIT). Please see [License File](LICENSE.md) for more information.
