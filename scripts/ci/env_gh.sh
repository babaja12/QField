#!/bin/bash -e

if [[ ${GITHUB_REF} == *"refs/heads"* ]]; then
	TMP_CI_BRANCH=${GITHUB_REF#refs/heads/}
elif [[ ${GITHUB_REF} == *"refs/tags"* ]]; then
	TMP_CI_TAG=${GITHUB_REF#refs/tags/}
	TMP_CI_BRANCH=${TMP_CI_TAG}
else
	TMP_CI_BRANCH=${TMP_CI_BRANCH:=""}
	TMP_CI_TAG=${TMP_CI_TAG:=""}
fi

TMP_CI_COMMIT_BEFORE=$(jq --raw-output .before "${GITHUB_EVENT_PATH}")
TMP_CI_COMMIT_AFTER=$(jq --raw-output .after "${GITHUB_EVENT_PATH}")
TMP_CI_PULL_REQUEST_NUMBER=${TMP_CI_PULL_REQUEST_NUMBER:=$(jq --raw-output ".pull_request.number" "${GITHUB_EVENT_PATH}")}

# -- SC2004: $/${} is unnecessary on arithmetic variables.
if ((TMP_CI_PULL_REQUEST_NUMBER > 0)); then
	TMP_CI_PULL_REQUEST=true
	TMP_CI_UPLOAD_ARTIFACT_ID=${TMP_CI_PULL_REQUEST_NUMBER}
else
	TMP_CI_PULL_REQUEST=false
	TMP_CI_UPLOAD_ARTIFACT_ID=${TMP_CI_BRANCH}
fi

export CI_BUILD_DIR=${CI_BUILD_DIR:=${GITHUB_WORKSPACE}}
export CI_COMMIT=${CI_COMMIT:=${GITHUB_SHA}}
export CI_BRANCH=${CI_BRANCH:=${TMP_CI_BRANCH}}
export CI_TAG=${CI_TAG:=${TMP_CI_TAG}}
export CI_PULL_REQUEST=${TMP_CI_PULL_REQUEST:=false}
export CI_PULL_REQUEST_NUMBER=${CI_PULL_REQUEST_NUMBER:=${TMP_CI_PULL_REQUEST_NUMBER}}
export CI_PULL_REQUEST_BRANCH=${CI_BRANCH:=${TMP_CI_BRANCH}}
export CI_COMMIT_RANGE=${CI_COMMIT_RANGE:="${TMP_CI_COMMIT_BEFORE}...${TMP_CI_COMMIT_AFTER}"}
export CI_REPO_SLUG=${CI_REPO_SLUG:=${GITHUB_REPOSITORY}}
export CI_UPLOAD_ARTIFACT_ID=${CI_UPLOAD_ARTIFACT_ID:=${TMP_CI_UPLOAD_ARTIFACT_ID}}
export CI_RUN_NUMBER=${GITHUB_RUN_NUMBER}
if [[ "${CI_TAG}" || ${GITHUB_REF} == "master" && ${CI_PULL_REQUEST} == "false" ]]; then
	export CI_USE_IOS_DIST_CERT=1
else
	export CI_USE_IOS_DIST_CERT=
fi

if [[ "${CI_TAG}" ]]; then
	export CI_PACKAGE_FILE_SUFFIX="${CI_TAG}"
	export APP_PACKAGE_NAME_SUFFIX=""
else
	export CI_PACKAGE_FILE_SUFFIX="dev-${CI_UPLOAD_ARTIFACT_ID}-${CI_COMMIT}"
	export APP_PACKAGE_NAME_SUFFIX="_dev"
fi

if [[ ${ALL_FILES_ACCESS} == "ON" ]]; then
	export APP_PACKAGE_NAME="qfield_all_access${APP_PACKAGE_NAME_SUFFIX}"
	export CI_PACKAGE_NAME="qfield_all_access"
else
	export APP_PACKAGE_NAME="qfield${APP_PACKAGE_NAME_SUFFIX}"
	export CI_PACKAGE_NAME="qfield"
fi

{
	echo "CI_BUILD_DIR=${CI_BUILD_DIR}"
	echo "CI_COMMIT=${CI_COMMIT}"
	echo "CI_BRANCH=${CI_BRANCH}"
	echo "CI_TAG=${CI_TAG}"
	echo "CI_SECURE_ENV_VARS=${CI_SECURE_ENV_VARS}"
	echo "CI_PULL_REQUEST=${CI_PULL_REQUEST}"
	echo "CI_PULL_REQUEST_NUMBER=${CI_PULL_REQUEST_NUMBER}"
	echo "CI_PULL_REQUEST_BRANCH=${CI_PULL_REQUEST_BRANCH}"
	echo "CI_COMMIT_RANGE=${CI_COMMIT_RANGE}"
	echo "CI_REPO_SLUG=${CI_REPO_SLUG}"
	echo "CI_UPLOAD_ARTIFACT_ID=${CI_UPLOAD_ARTIFACT_ID}"
	echo "CI_PACKAGE_NAME=${CI_PACKAGE_NAME}"
	echo "CI_PACKAGE_FILE_SUFFIX=${CI_PACKAGE_FILE_SUFFIX}"
	echo "CI_RUN_NUMBER=${CI_RUN_NUMBER}"
	echo "CI_USE_IOS_DIST_CERT=${CI_USE_IOS_DIST_CERT}"
	echo "APP_PACKAGE_NAME=${APP_PACKAGE_NAME}"
} >>$GITHUB_ENV

echo ""
echo "CI_BUILD_DIR: ${CI_BUILD_DIR}"
echo "CI_COMMIT: ${CI_COMMIT}"
echo "CI_BRANCH: ${CI_BRANCH}"
echo "CI_TAG: ${CI_TAG}"
echo "CI_SECURE_ENV_VARS: ${CI_SECURE_ENV_VARS}"
echo "CI_PULL_REQUEST: ${CI_PULL_REQUEST}"
echo "CI_PULL_REQUEST_NUMBER: ${CI_PULL_REQUEST_NUMBER}"
echo "CI_PULL_REQUEST_BRANCH: ${CI_PULL_REQUEST_BRANCH}"
echo "CI_COMMIT_RANGE: ${CI_COMMIT_RANGE}"
echo "CI_REPO_SLUG: ${CI_REPO_SLUG}"
echo "CI_UPLOAD_ARTIFACT_ID: ${CI_UPLOAD_ARTIFACT_ID}"
echo "CI_RUN_NUMBER: ${CI_RUN_NUMBER}"
echo "CI_USE_IOS_DIST_CERT: ${CI_USE_IOS_DIST_CERT}"
echo "APP_PACKAGE_NAME: ${APP_PACKAGE_NAME}"
