import kaggle

kaggle.api.authenticate()

kaggle.api.dataset_download_files('eduardolicea/healthcare-dataset', path='./tmp', unzip=True)

