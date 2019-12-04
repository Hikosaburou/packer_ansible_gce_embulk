# packer_gce_embulk
GCEでEmbulk実行イメージを作ってみる

## サービスアカウントキー発行

https://cloud.google.com/iam/docs/creating-managing-service-accounts?hl=ja#iam-service-accounts-create-gcloud
https://cloud.google.com/iam/docs/granting-roles-to-service-accounts?hl=ja#granting_access_to_a_service_account_for_a_resource
https://cloud.google.com/iam/docs/creating-managing-service-account-keys?hl=ja#creating_service_account_keys

```
$ gcloud beta iam service-accounts create packer --description "Allow to build Compute Engine images (for Packer)"
$ gcloud projects add-iam-policy-binding [YOUR_PROJECT_ID] --member serviceAccount:packer@[YOUR_PROJECT_ID].iam.gserviceaccount.com --role roles/compute.networkUser
$ gcloud projects add-iam-policy-binding [YOUR_PROJECT_ID] --member serviceAccount:packer@[YOUR_PROJECT_ID].iam.gserviceaccount.com --role roles/compute.instanceAdmin.v1
$ gcloud projects add-iam-policy-binding [YOUR_PROJECT_ID] --member serviceAccount:packer@[YOUR_PROJECT_ID].iam.gserviceaccount.com --role roles/iam.serviceAccountUser

$ gcloud iam service-accounts keys create ~/key.json \
  --iam-account packer@[YOUR_PROJECT_ID].iam.gserviceaccount.com
```

`GOOGLE_APPLICATION_CREDENTIALS` にサービスアカウントキーの相対パスを埋め込む。

```
export GOOGLE_APPLICATION_CREDENTIALS=~/key.json
```

direnv の使用を推奨。

## variables.json

Packer 設定ファイル内の一部変数は variables.json に定義する

```
{
    "project_id": "PROJECT_ID",
    "image_family": "IMAGE_FAMILY",
    "account_file_path": "{{ env `GOOGLE_APPLICATION_CREDENTIALS` }}"
}
```

## packer 実行

```
packer build --var-file=variable.json embulk.json
```
