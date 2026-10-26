Example with multiple input types
-------------------------------------

* init

  ```shell
  tofu init
  ```

* Run Apply
  ```shell
  tofu apply -var-file=sample.tfvars -auto-approve
  ```

  * Copy sample.tfvars to terraform.tfvars, then run 
    
    ```shell
      tofu apply -auto-approve
    ```

    * terraform.tfvars will automatically loaded

* Run Destroy
  ```shell
  tofu destroy -var-file=sample.tfvars -auto-approve
  ```
