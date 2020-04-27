# Docker Yocto Builder

This is a simple docker image with all requirements to build a yocto project based linux image.
This no includes any yocto version or yocto layer, this needs be included as a volume of specific project.

## Why use docker to build yocto projects?

* You can use a host updated SO with yocto keeping the compatibility of Yocto Project;
* You can use any computer to build only require docker installed;
* You can keep your computer lean without a loots of libraries and tools;
* All your team can use a standard base development environment;