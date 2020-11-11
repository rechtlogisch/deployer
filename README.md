# PHP Deployer and Composer for Bitbucket Pipelines

A custom image for Bitbucket Pipelines to install dependencies, run tests and deploy code to remote servers.  

Based on the current stable PHP CLI Alpine.

Features:
- Composer 2
- Deployer with Recipes
- Very small size (ca. 44 MB)

Branch ``next`` contains the current development image of PHP CLI Alpine.

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

* [List of PHP modules](https://github.com/rechtlogisch/deployer/wiki/List-of-PHP-modules)

## Known issues

* [Access private repositories with your Pipeline SSH Key](https://github.com/rechtlogisch/deployer/wiki/Access-private-repositories-with-your-Pipeline-SSH-Key)

## Changelog

Please see [CHANGELOG](CHANGELOG.md) for more information on what has changed recently.

## Contributing

Please see [CONTRIBUTING](.github/CONTRIBUTING.md) for details.

## Security Vulnerabilities

Please review [our security policy](../../security/policy) on how to report security vulnerabilities.

## Credits

- [:author_name](https://github.com/:author_username)
- [All Contributors](../../contributors)

## License

The MIT License (MIT). Please see [License File](LICENSE.md) for more information.
