## Repo for scripts and notes for ADT project

1. Proxy chaining

    
  ```
  sudo apt-get install proxychains
  ```
 
  - copy `proxychains.conf` into `/etc/proxychains.conf`

  - when running `nmap` use proxy chaining as follows:
    
  ```
  sudo proxychains nmap -sT SOME_IP_ADDRESS
  ```

2. Port scanning
  
  


