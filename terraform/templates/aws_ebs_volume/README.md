
## Verify Terraform Refresh

1. set env vars

*  export AWS_ACCESS_KEY_ID="<YOUR-ACCESS-KEY-ID>"
*  export AWS_SECRET_ACCESS_KEY="<YOUR-SECRET-ACCESS-KEY>"

2. Run terraform ( or tofu ) apply 

   ```
   $ tofu apply

   $ tofu show
   ```

3. Modify size in aws console

   1. Log in to the AWS Management Console.
   2. Navigate to EC2 > Elastic Block Store > Volumes.
   3. Select your volume (Terraform-Test-Volume).
   4. Click Actions > Modify Volume.
      Change the Size from 10 to 15 GB and click Modify

4. Sync State

   ```
   $ tofu apply -refresh-only

   $ tofu show
   ```

5. Destory the volume

   ```
   $ tofu destroy
   ```
   


