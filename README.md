# PHP with Deployer and Composer

[![Docker Cloud automated build](https://img.shields.io/docker/cloud/automated/rechtlogisch/deployer)](https://hub.docker.com/r/rechtlogisch/deployer)
[![Docker Cloud build status](https://img.shields.io/docker/cloud/build/rechtlogisch/deployer)](https://hub.docker.com/r/rechtlogisch/deployer/builds)

A custom image for Bitbucket Pipelines to install dependencies, run tests and deploy code to remote servers.  

Based on the current stable PHP CLI Alpine.

Features:
- Composer 2
- Deployer with Recipes
- Very small size

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
        name: Test
        caches:
          - composer
        script:
          - composer install --prefer-dist --no-ansi --no-interaction --no-progress --no-scripts 
          - composer test
    - step:
        name: Deploy
        deployment: production
        script:
          - dep deploy production
```

Add `deploy.php` and `hosts.yml` to your repository (cf. [Deployer documentation](https://deployer.org/docs/getting-started.html))

To run tests with `composer test` add for example `vendor/bin/pest` to the `scripts` property of your `composer.json` (cf. [Composer documentation](https://getcomposer.org/doc/articles/scripts.md#defining-scripts) and [Pest PHP](https://pestphp.com))

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
