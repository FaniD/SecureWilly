# SecureWilly

![N|Solid](https://raw.githubusercontent.com/FaniD/SecureWilly/master/SecureWilly300px.png)

SecureWilly is a software for automatically creating secure and efficient AppArmor profiles for every service of a docker project, adjusted to each service's task but aware of their coordination, and especially defending isolation between host and containers.

## Getting started

### Prerequisites

Make sure you have installed all the required packages listed in Requirements/requirements.sh

### Usage
1. Copy directory "Parser" under the path on your host where Dockerfiles/docker compose file of your docker project exist.
2. Make sure that you have knowledge about the input that SecureWilly will require when you run it. You can either give your input interactively or in a file - in directory Parser you can see an input_sample. The requirements of the input are given below:

  * The number of services that need a profile for your project. A service is defined by a docker image, either it is built by Dockerfile or uses an existing image, with or without docker-compose file.
  
  * The name of each service following the next rules:
  
    a. The names should not be used for other purposes like named volumes, network etc
    
    b. If you use a docker-compose.yml, make sure that you give the same names of services you used inside the yml file and with the same order as they are in it.
    
    c. If you do not use docker-compose.yml, the names of services should be identical to the names of the corresponding images. Do not worry about special characters, just give the exact same name of the image and let SecureWilly worry about it.
    
  * If there are Dockerfiles to provide for each service or a Docker Compose file then you will be asked to give the full path to the file (<path_to_dockerfile>/Dockerfile_or_DockerComposefile), otherwise you should type N.
  
  * The name of an internal network, otherwise you should type N.
  
  * Then you will be prompted give a testplan that you want to execute inside the container. Make sure you follow the next rules:
  
    a. Give a command per line
    
    b. Include the docker run commands or docker-compose commands with which you will start and stop your container(s).
    
    c. If no docker-compose is used, it is wise to use the --name flag to run your containers. If you do not do that, SecureWilly will name your containers after the corresponding service name.
    
    d. If your image is getting built by Dockerfile, make sure to give the same name to the image as the service you gave before, using docker build <path_to_Dockerfile> -t <service>
    
    e. Do NOT use flag --security-opt to run your containers.
    
    f. If you docker run servers os daemons in general, make sure you add flag -d
    
    g. Type Done when you're finished.
    
    Remember, you are the one who knows how your program works. The commands will be executed in a script, so take all the actions needed to make it work.

3. Run SecureWilly_UI.sh: ./SecureWilly_UI.sh | ./SecureWilly_UI.sh < input_sample

4. A directory named "parser_output" will be created and the profiles produced can be found in it. Some mini docker-compose files for each service are also produced and can be used by the user, in case there is no docker-compose file.

## Built With

* Bash scripting
* Python scripting

## Authors

**Fani Dimou** - For any questions you can reach me at fani.dimou92@gmail.com

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details

## Acknowledgments

* Inspiration by [@giagiannis](https://github.com/giagiannis)
* Trademark made by Katerina Mavromoustakaki
