#!/usr/bin/env bash

# set -e: exit asap if a command exits with a non-zero status
set -e

###################
# Echo with Error #
###################
echoerr() { printf "%s\n" "$*" >&2; }

########################
# Print error and exit #
########################
die () {
  echoerr "ERROR: $1"
  # if $2 is defined AND NOT EMPTY, use $2; otherwise, set to "160"
  errnum=${2-160}
  exit $errnum
}

#########################
# Update the Change log #
#########################
generate_LATEST_RELEASE_by_updating_TBDs() {
  sed -i -- "s/NEXT_RELEASE/${NEXT_RELEASE}/g" LATEST_RELEASE.md
  sed -i -- "s/PREV_RELEASE/${PREV_RELEASE}/g" LATEST_RELEASE.md
  sed -i -- "s/TBD_DIGEST/${TBD_DIGEST}/g" LATEST_RELEASE.md
  sed -i -- "s/TBD_IMAGE_SIZE/${TBD_IMAGE_SIZE}/g" LATEST_RELEASE.md
  sed -i -- "s/TBD_DOCKER_VERS/${TBD_DOCKER_VERS}/g" LATEST_RELEASE.md
  sed -i -- "s/TBD_DOCKER_BUILD/${TBD_DOCKER_BUILD}/g" LATEST_RELEASE.md
  sed -i -- "s/TBD_DOCKER_COMPOSE_VERS/${TBD_DOCKER_COMPOSE_VERS}/g" LATEST_RELEASE.md
  sed -i -- "s/TBD_DOCKER_COMPOSE_BUILD/${TBD_DOCKER_COMPOSE_BUILD}/g" LATEST_RELEASE.md
  sed -i -- "s/TBD_HOST_UNAME/${TBD_HOST_UNAME}/g" LATEST_RELEASE.md
  sed -i -- "s/TBD_DATE/${TBD_DATE}/g" LATEST_RELEASE.md
  sed -i -- "s/TBD_CHROME_STABLE/${TBD_CHROME_STABLE}/g" LATEST_RELEASE.md
  sed -i -- "s/TBD_CHROME_DRIVER/${TBD_CHROME_DRIVER}/g" LATEST_RELEASE.md
  sed -i -- "s/TBD_GECKO_DRIVER/${TBD_GECKO_DRIVER}/g" LATEST_RELEASE.md
  sed -i -- "s/TBD_CHROMEDRIVER_COMMIT/${TBD_CHROMEDRIVER_COMMIT}/g" LATEST_RELEASE.md
  sed -i -- "s/TBD_FIREFOX_VERSION/${TBD_FIREFOX_VERSION}/g" LATEST_RELEASE.md
  sed -i -- "s/TBD_SELENIUM_VERSION/${TBD_SELENIUM_VERSION}/g" LATEST_RELEASE.md
  sed -i -- "s/TBD_SELENIUM_REVISION/${TBD_SELENIUM_REVISION}/g" LATEST_RELEASE.md
  sed -i -- "s/TBD_PYTHON_VERSION/${TBD_PYTHON_VERSION}/g" LATEST_RELEASE.md
  sed -i -- "s/TBD_JAVA_BUILD/${TBD_JAVA_BUILD}/g" LATEST_RELEASE.md
  sed -i -- "s/TBD_JAVA_VENDOR/${TBD_JAVA_VENDOR}/g" LATEST_RELEASE.md
  sed -i -- "s/TBD_TIME_ZONE/${TBD_TIME_ZONE}/g" LATEST_RELEASE.md
  sed -i -- "s/TBD_IMAGE_VERSION/${TBD_IMAGE_VERSION}/g" LATEST_RELEASE.md
  sed -i -- "s/UBUNTU_FLAVOR/${UBUNTU_FLAVOR}/g" LATEST_RELEASE.md
  sed -i -- "s/UBUNTU_DATE/${UBUNTU_DATE}/g" LATEST_RELEASE.md
}

increment_global_patch_level_for_GA() {
  local current_patch_level=$(cat GLOBAL_PATCH_LEVEL.txt)
  local global_patch_level=$((current_patch_level+1))

  echo $global_patch_level > GLOBAL_PATCH_LEVEL.txt
}

#############################################################
# Add commits grouped by authors in between LATEST_RELEASE.md #
#############################################################
add_commits_to_LATEST_RELEASE() {
  # Get commits history grouped by author
  # https://www.kernel.org/pub/software/scm/git/docs/git-log.html#_pretty_formats
  # e.g. git shortlog --format="[%h] %s" 3.6.0-p6..HEAD
  # e.g. git shortlog --format="[%h] %s" --no-merges --author='^(?!Leo Gallucci Bot).*$' --perl-regexp 3.6.0-p6..HEAD
  rm -f git_shortlog.stdout
  git shortlog \
    --format="[%h] %s" \
    --no-merges \
    --author='^(?!Leo Gallucci Bot).*$' --perl-regexp \
    ${PREV_RELEASE}..HEAD > git_shortlog.stdout

  # Delete empty lines
  sed -i -e '/^\s*$/d' git_shortlog.stdout

  # Add some indentation prefix
  sed -i -e 's/^/    + /' git_shortlog.stdout

  # Fix prefix for commits lines
  sed -i -e 's/^\s*+\s*\[/        * \[/' git_shortlog.stdout

  # Use a temporal file in order to inject the log in the middle
  rm -f temp.md
  mv LATEST_RELEASE.md temp.md

  # Add first 2 lines to the final new release change log part
  head -n 2 temp.md > LATEST_RELEASE.md

  # Add git short log with indent `    + ` in the 3rd line of LATEST_RELEASE.md
  cat git_shortlog.stdout >> LATEST_RELEASE.md

  # Add the rest of the original LATEST_RELEASE.md
  tail -n +3 temp.md >> LATEST_RELEASE.md

  # Remove intermediate files
  rm temp.md git_shortlog.stdout
}

add_LATEST_RELEASE_to_top_of_CHANGELOG() {
  rm -f temp.md
  cat LATEST_RELEASE.md | cat - CHANGELOG.md > temp.md
  rm -f CHANGELOG.md
  mv temp.md CHANGELOG.md
}

travis_tag_checks() {
  if ! grep -Po '(?<=## )([a-z0-9\.-]+)' CHANGELOG.md | grep "${TRAVIS_TAG}"; then
    die "TRAVIS_TAG='${TRAVIS_TAG}' should be already present in CHANGELOG.md"
  fi

  if hub release | grep "${TRAVIS_TAG}"; then
    die "TRAVIS_TAG='${TRAVIS_TAG}' has already being released according to: hub release"
  fi
}

bump_setup_and_checks() {
  if grep -Po '(?<=## )([a-z0-9\.-]+)' CHANGELOG.md | grep "${NEXT_RELEASE}"; then
    echo "WARN: NEXT_RELEASE='${NEXT_RELEASE}' is already present in CHANGELOG.md"
    echo "WARN: Will abort the bump as it's happening probably in parallel with another one"
    exit 0
  fi

  if hub release | grep "${NEXT_RELEASE}"; then
    echo "WARN: NEXT_RELEASE='${NEXT_RELEASE}' has already being released according to: hub release"
    echo "WARN: Will abort the bump as it's happening probably in parallel with another one"
    exit 0
  fi

  # Remove LATEST_RELEASE.md as we will overwrite it
  rm LATEST_RELEASE.md

  # Base the new one from the template
  cp LATEST_RELEASE_TEMPLATE.md LATEST_RELEASE.md
}

####################################
# Git add and commit local changes #
####################################
git_diff_add_commit() {
  echo "deploy::git_diff_add_commit"
  # set -e: exit asap if a command exits with a non-zero status
  # set -x: print each command right before it is executed
  set -xe
  git --no-pager diff --unified=0 CHANGELOG.md
  git status
  git add LATEST_RELEASE.md
  git add CHANGELOG.md
  git add GLOBAL_PATCH_LEVEL.txt
  git add capabilities.json
  git add images/grid3_console.png
  git commit -m "${NEXT_RELEASE}: Update CHANGELOG, image digest, capabilities & png"
  git --no-pager log -n3
  git branch
}

gen_and_cp_capabilities_and_png() {
  docker exec grid generate_capabilities_json > capabilities.json
  docker exec -t grid python_test chrome true
  docker cp grid:/test/console.png ./images/grid3_console.png
}

#######################################
# Docker login, tag and push selenium #
#######################################
docker_login_tag_push() {
  echo "script_push::docker_login_tag_push"

  [ "${TRAVIS_TAG}" == "" ] && die "Need env var TRAVIS_TAG"
  [ "${DOCKER_USERNAME}" == "" ] && die "Need env var DOCKER_USERNAME to push to docker"
  [ "${DOCKER_PASSWORD}" == "" ] && die "Need env var DOCKER_PASSWORD to push to docker"

  docker login -u="${DOCKER_USERNAME}" -p="${DOCKER_PASSWORD}"
  echo "Logged in to docker with user '${DOCKER_USERNAME}'"
  echo "docker tag and docker push using TRAVIS_TAG=${TRAVIS_TAG}"
  docker tag selenium:latest elgalu/selenium:${TRAVIS_TAG}
  docker tag selenium:latest elgalu/selenium:latest

  # e.g. TAG_VERSION_MAJOR="3"
  TAG_VERSION_MAJOR="${TRAVIS_TAG::1}"
  echo "TAG_VERSION_MAJOR=${TAG_VERSION_MAJOR}"
  docker tag selenium:latest elgalu/selenium:${TAG_VERSION_MAJOR}
  # e.g. TAG_VERSION_MAJ_MINOR="3.3"
  TAG_VERSION_MAJ_MINOR="${TRAVIS_TAG::3}"
  echo "TAG_VERSION_MAJ_MINOR=${TAG_VERSION_MAJ_MINOR}"
  docker tag selenium:latest elgalu/selenium:${TAG_VERSION_MAJ_MINOR}
  # e.g. TAG_VERSION_MAJ_MIN_PATCH="3.3.1"
  TAG_VERSION_MAJ_MIN_PATCH="${TRAVIS_TAG::5}"
  echo "TAG_VERSION_MAJ_MIN_PATCH=${TAG_VERSION_MAJ_MIN_PATCH}"
  docker tag selenium:latest elgalu/selenium:${TAG_VERSION_MAJ_MIN_PATCH}

  # Push this version with all the corresponding tags
  docker push elgalu/selenium:${TAG_VERSION_MAJOR}
  docker push elgalu/selenium:${TAG_VERSION_MAJ_MINOR}
  docker push elgalu/selenium:${TAG_VERSION_MAJ_MIN_PATCH}
  docker push elgalu/selenium:${TRAVIS_TAG} | tee docker_push.log
  docker push elgalu/selenium:latest

  # Update Docker README.md badges
  curl -XPOST "https://hooks.microbadger.com/images/elgalu/selenium/2blr1ujGSTcUtm3HnU0-h5m6yLY=" || true
}

#############################
# Use Github API to release #
#############################
github_release_from_LATEST_RELEASE() {
  echo "Release via GH API"

  [ -z "${GITHUB_TOKEN}" ] && die "Need env var GITHUB_TOKEN"
  [ "${TRAVIS_TAG}" == "" ] && die "Need env var TRAVIS_TAG"

  hub --version || die "github.com/hub is not installed!"

  # Let's remove the first line
  sed -i '1d' LATEST_RELEASE.md

  # We need to separate the release title from its description
  rm -f temp.md
  echo -e "${TRAVIS_TAG}\n" | cat - LATEST_RELEASE.md > temp.md
  rm LATEST_RELEASE.md
  mv temp.md LATEST_RELEASE.md

  # We need to gather the chrome.deb artifact to include it in the release
  CHROME_VERSION=$(docker exec grid chrome_stable_version) \
    || die "while trying to get CHROME_VERSION"

  CHROME_DEB_FILE_NAME="google-chrome-stable_${CHROME_VERSION}_amd64"
  wget -nv -O "${CHROME_DEB_FILE_NAME}.deb" \
    "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"

  md5sum ${CHROME_DEB_FILE_NAME}.deb > ${CHROME_DEB_FILE_NAME}.md5
  shasum ${CHROME_DEB_FILE_NAME}.deb > ${CHROME_DEB_FILE_NAME}.sha

  # If the release exists, delete it
  if hub release | grep -q "^${TRAVIS_TAG}\$"; then
    hub release delete "${TRAVIS_TAG}"
  fi

  # https://github.com/github/hub/blob/master/share/man/man1/hub.1.ronn#L123
  # export HUB_VERBOSE=1

  # https://github.com/github/hub/blob/master/commands/release.go#L59
  # TODO: Add real assents (.deb, ...)
  hub release create \
    -a "${CHROME_DEB_FILE_NAME}.md5" \
    -a "${CHROME_DEB_FILE_NAME}.sha" \
    -a "${CHROME_DEB_FILE_NAME}.deb" \
    -F "LATEST_RELEASE.md" \
    "${TRAVIS_TAG}"
}

#########################
# Git push changes, tag #
#########################
git_tag_and_push() {
  echo "deploy::git_tag_and_push"
  if git push github HEAD:master >git_push_master.log 2>&1; then \
    failed=false; else failed=true; fi
  # hide secrets
  sed -i -- "s/${GITHUB_TOKEN}/\[SECRET\]/g" git_push_master.log || true
  if [ ${failed} == "true" ]; then
    echoerr "Failed to git push to master!"
    cat git_push_master.log 1>&2
    exit 1
  else
    cat git_push_master.log
  fi

  git tag -f "${NEXT_RELEASE}"
  git tag -f latest

  if git push --tags -f >git_push_tags.log 2>&1; then \
    failed=false; else failed=true; fi
  # hide secrets
  sed -i -- "s/${GITHUB_TOKEN}/\[SECRET\]/g" git_push_tags.log || true
  if [ ${failed} == "true" ]; then
    echoerr "Failed to push git tags!"
    cat git_push_master.log 1>&2
    exit 2
  else
    cat git_push_master.log
  fi
}

#################################
# Git config name, email, stuff #
#################################
git_config() {
  echo "update_changelog_and_git_tag::git_config"
  git config --global push.default simple
  git config --global user.name "Leo Gallucci Bot"
  git config --global user.email "elgalu3+bot@gmail.com"
}

################################################
# Git create branch, merge, keep local changes #
################################################
git_co_fetch_merge_stash() {
  echo "update_changelog_and_git_tag::git_co_fetch_merge_stash"
  git checkout -b travis-${TRAVIS_BUILD_NUMBER}
  git remote add github "https://elgalubot:${GITHUB_TOKEN}@github.com/elgalu/docker-selenium.git"
  git fetch github
  # git stash save || true
  git checkout -t github/master -b github/master
  echo "Will git merge into master"
  if ! timeout --foreground "30s" git merge travis-${TRAVIS_BUILD_NUMBER}; then
    echo "WARN: Timed out on git merge!" 1>&2
  fi
  # git stash pop || true
}

#####################################################
# Docker run `grid` so we can fetch actual versions #
#####################################################
ensure_docker_run_dosel() {
  local docker_selenium_image_count=$(docker images selenium:latest | grep "selenium" | wc -l)

  if [ ${docker_selenium_image_count} -eq 0 ]; then
      echo "Seems that selenium:latest image is not around"
      exit 1
  fi

  if [[ $(docker ps -f "name=grid" --format '{{.Names}}') != "grid" ]]; then
    docker run --name=grid -d -e VIDEO=false selenium:latest
    sleep 1
    docker exec grid wait_all_done 40s
  fi
}

########
# Main #
########
if [ "${TRAVIS_PULL_REQUEST}" == "true" ]; then
  echo "This is a pull request so no elgalubot commits nor push to docker"
  exit 0
fi

ensure_docker_run_dosel

#####################################################
# Checks that versions are consistent among artifacts
# == CHANGELOG.md
# == github latest release
# == LATEST_RELEASE.md
PREV_RELEASE_FROM_CHANGELOG=$(grep -Po '(?<=## )([a-z0-9\.-]+)' CHANGELOG.md | head -n 1)
PREV_RELEASE_FROM_LATEST_RELEASE=$(grep -Po '(?<=## )([a-z0-9\.-]+)' LATEST_RELEASE.md | head -n 1)

[ "${PREV_RELEASE_FROM_CHANGELOG}" == "${PREV_RELEASE_FROM_LATEST_RELEASE}" ] || die \
  "Last release from CHANGELOG='${PREV_RELEASE_FROM_CHANGELOG}' doesn't match PREV_RELEASE_FROM_LATEST_RELEASE='${PREV_RELEASE_FROM_LATEST_RELEASE}'"

if ! docker image inspect --format='{{.RepoDigests}}' selenium:latest; then
  die "Unable to fetch .RepoDigests from selenium:latest image"
fi

if docker image inspect --format='{{.RepoDigests}}' selenium:latest | grep -E "^\[\]$"; then
  die ".RepoDigests at selenium:latest is an empty array"
fi

TBD_DIGEST=$(docker image inspect --format='{{.RepoDigests}}' selenium:latest | grep -Po '(?<=@)([a-z0-9:]+)')

TBD_IMAGE_SIZE=$(docker images --format "{{.Size}}" selenium:latest) \
  || die "while trying to get TBD_IMAGE_SIZE"

TBD_DOCKER_VERS=$(docker --version 2>&1 | grep -Po '(?<=version )([a-z0-9\.]+)') \
  || die "while trying to get TBD_DOCKER_VERS"

TBD_DOCKER_BUILD=$(docker --version 2>&1 | grep -Po '(?<=build )([a-z0-9\.]+)') \
  || die "while trying to get TBD_DOCKER_BUILD"

TBD_DOCKER_COMPOSE_VERS=$(docker-compose --version 2>&1 | grep -Po '(?<=version )([a-z0-9\.]+)') \
  || die "while trying to get TBD_DOCKER_COMPOSE_VERS"

TBD_DOCKER_COMPOSE_BUILD=$(docker-compose --version 2>&1 | grep -Po '(?<=build )([a-z0-9\.]+)') \
  || die "while trying to get TBD_DOCKER_COMPOSE_BUILD"

uname -rm 2>&1 >uname_rm.log || true
TBD_HOST_UNAME=$(cat uname_rm.log) \
  || die "while trying to get TBD_HOST_UNAME"
rm -f uname_rm.log

TBD_DATE=$(date +%F) \
  || die "while trying to get TBD_DATE"

TBD_CHROME_STABLE=$(docker exec grid chrome_stable_version) \
  || die "while trying to get TBD_CHROME_STABLE"

TBD_CHROME_DRIVER=$(docker exec grid chromedriver_version) \
  || die "while trying to get TBD_CHROME_DRIVER"

TBD_GECKO_DRIVER=$(docker exec grid geckodriver_version) \
  || die "while trying to get TBD_GECKO_DRIVER"

TBD_CHROMEDRIVER_COMMIT=$(docker exec grid chromedriver_commit_version) \
  || die "while trying to get TBD_CHROMEDRIVER_COMMIT"

TBD_FIREFOX_VERSION=$(docker exec grid firefox_version) \
  || die "while trying to get TBD_FIREFOX_VERSION"

TBD_SELENIUM_VERSION=$(docker exec grid selenium_version) \
  || die "while trying to get TBD_SELENIUM_VERSION"

TBD_SELENIUM_REVISION=$(docker exec grid selenium_revision_version) \
  || die "while trying to get TBD_SELENIUM_REVISION"

TBD_PYTHON_VERSION=$(docker exec grid python_version) \
  || die "while trying to get TBD_PYTHON_VERSION"

TBD_JAVA_BUILD=$(docker exec grid java_build_version) \
  || die "while trying to get TBD_JAVA_BUILD"

TBD_JAVA_VENDOR=$(docker exec grid java_vendor_version) \
  || die "while trying to get TBD_JAVA_VENDOR"

TBD_TIME_ZONE="$(docker exec grid printenv TZ | sed -r 's/[\/]+/\\\//g')" \
  || die "while trying to get TBD_TIME_ZONE"

TBD_IMAGE_VERSION=$(docker exec grid cat VERSION) \
  || die "while trying to get VERSION"

UBUNTU_FLAVOR=$(docker exec grid cat UBUNTU_FLAVOR) \
  || die "while trying to get UBUNTU_FLAVOR"

UBUNTU_DATE=$(docker exec grid cat UBUNTU_DATE) \
  || die "while trying to get UBUNTU_DATE"

NEXT_SELENIUM_VERSION="${TBD_SELENIUM_VERSION}"
PREV_RELEASE="${PREV_RELEASE_FROM_CHANGELOG}"
PREV_SELENIUM_VERSION=$(echo "${PREV_RELEASE}" | grep -Po '([0-9\.]+)' | head -n 1)
PREV_PATCH_LEVEL=$(echo "${PREV_RELEASE}" | grep -Po '(?<=p)([0-9]+)')

if [ "$1" == "bump" ]; then

  # "bump" purpose:
  # - Bump version taking Selenium version into account and last patch level
  # - Create LATEST_RELEASE.md from LATEST_RELEASE_TEMPLATE.md
  # - Update LATEST_RELEASE.md with accumulated commits
  # - Update the CHANGELOG by adding LATEST_RELEASE.md on top
  # - Git commit
  # - Git tag the bumped version to trigger the "release" section

  if [ "${TRAVIS_TAG}" != "" ]; then
    die "This commit is already tagged. Something went wrong while bumping."
  fi

  PREV_RELEASE_FROM_HUB=$(hub release | head -n 1)

  [ "${PREV_RELEASE_FROM_CHANGELOG}" == "${PREV_RELEASE_FROM_HUB}" ] || die \
    "Last release from CHANGELOG='${PREV_RELEASE_FROM_CHANGELOG}' doesn't match /docker-selenium/releases: '${PREV_RELEASE_FROM_HUB}'"

  git_config

  git_co_fetch_merge_stash

  if [ "${PREV_SELENIUM_VERSION}" == "${NEXT_SELENIUM_VERSION}" ]; then
    NEXT_PATCH_LEVEL=$((PREV_PATCH_LEVEL+1))
  else
    # If the Selenium version changed, restart the patch level
    NEXT_PATCH_LEVEL=12
  fi

  NEXT_RELEASE="${NEXT_SELENIUM_VERSION}-p${NEXT_PATCH_LEVEL}"

  bump_setup_and_checks

  increment_global_patch_level_for_GA

  generate_LATEST_RELEASE_by_updating_TBDs

  add_commits_to_LATEST_RELEASE

  add_LATEST_RELEASE_to_top_of_CHANGELOG

  gen_and_cp_capabilities_and_png

  git_diff_add_commit

  git_tag_and_push

elif [ "$1" == "release" ]; then

  # "release" purpose:
  # - Docker push using the current ${TRAVIS_TAG}
  # - Github release using the generated LATEST_RELEASE.md

  if [ "${TRAVIS_TAG}" == "" ]; then
    die "This commit is not tagged. Something went bad while releasing."
  fi

  if [ "${TRAVIS_TAG}" == "latest" ]; then
    echo "Tag latest will not trigger a push and release"
    exit 0
  fi

  travis_tag_checks

  docker_login_tag_push

  github_release_from_LATEST_RELEASE

else

  die "Unsupported argument '$1' for $0 deploy script"

fi

# Travis env vars:
# https://github.com/travis-ci/docs-travis-ci-com/blob/gh-pages/user/environment-variables.md
#  TRAVIS_PULL_REQUEST_BRANCH: If the current job is a pull request, the name of the branch from which the PR orginated
