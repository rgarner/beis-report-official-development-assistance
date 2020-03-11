# Deployment process

## Production

As outlined in the [dxw development workflow guide](http://playbook.dxw.com/#/guides/development-workflow?id=deploying), production deploys are done by manually merging develop into master. To give us a slightly more formal process around what gets deployed and when and also to give us visibility into the things that have been deployed, we additionally follow these steps when releasing to production:

Releases are documented in the [CHANGELOG](CHANGELOG.md) following the [Keep a changelog](https://keepachangelog.com/en/1.0.0/) format.

When a new release is deployed to production, a new second-level heading should be created in CHANGELOG.md with the release number and details of what has changed in this release.

The heading should link to a Github URL at the bottom of the file, which shows the differences between the current release and the previous one. For example:

### Example

```
## [release-1]
- A change
- Another change

[release-1]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-0...release-1
```

### Steps

1. Create a release branch and make a pull request
  * Create a branch from develop for the release called release-X where X is the release number
  * Update CHANGELOG.md to:
    document the changes in this release in a bullet point form
    add a link to the diff at the bottom of the file
  * Document the changes in the commit message as well
  * Create a tag for the release in the format release-X
  * git push --follow-tags <your-branch-name>
  * Create a pull request to merge that release into master with content from the CHANGELOG.md
  * Get that pull request reviewed and approved
2. Review and merge the release pull request
  * Confirm the release candidate and perform any prerequisites such as environment variables or third-party service configuration
  * The pull request should be reviewed to confirm that the changes in the release are safe to ship and that CHANGELOG.md accurately reflects the changes included in the release.
  * Merge the pull request
3. Announce the release
    Let the team know about the release. This is posted in Slack under #beis-roda. Typical form is:

    ```
    @here :badger: Release N of RODA going to production :badger:
    ```

## Staging

1. Open a pull request back into the `develop` branches with your changes
1. Get that pull request code reviewed and approved
1. Check that any prerequisite changes to things like environment variables or third-party service configuration is ready
1. Merge the pull request

The changes should be automatically applied by Travis. [You can track the progress of Travis jobs at this link](https://travis-ci.org/UKGovernmentBEIS/beis-report-official-development-assistance).

## Migrations

These should be automatically run when new containers are started during a deployment. This instruction is included in the app/docker-entrypoint.sh.