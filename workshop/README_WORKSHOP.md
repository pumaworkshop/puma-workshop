# Puma Workshop

Welcome to the Puma workshop! This section of the repository is dedicated to guiding you through the process of learning
how to use Puma and how to contribute to Puma. 

### Prerequisites

Before you begin, make sure you have the following:

- Familiarity with Python
- Either: 
  1. If provided with a VM that has Puma pre-installed:
     - Have the workshop VM imported and running:
       - On Windows: [Install Virtualbox](https://www.virtualbox.org/wiki/Downloads) and add the provided VM (The green "Add" button on the top right)
       - On Linux: Install Qemu: `sudo apt-get install qemu-system virt-manager`
         - Add the image to Qemu:
           - Open the program 'Virtual Image Manager'
           - Click on the icon for 'Create a new virtual machine'
           - Select 'Import existing disk image'
           - Provide the path to the qcow2 file, for the operating system select 'Generic default (generic)'
           - For memory select 4096, for cpu select 4
           - Last, give the machine a name you can recognize it by
       - TODO MacOS
     - Have Android Studio installed with an emulator running on your host machine (see [Puma README](../README.md#requirements))
  2. Install the requirements with the installation scripts in [the install folder](../install) described in the [Puma README](../README.md#requirements) and the [CONTRIBUTING.md](../CONTRIBUTING.md#development-installation), and:
     - Add the following lines to your ipython_config.py file (probably in `~/.ipython/profile_default/`(Linux), or `C:\Users\<YourUserName>\.ipython\profile_default\`(Windows)): 
     ```
       import os
       os.chdir('/path/to/puma-workshop')
       c.InteractiveShellApp.extensions = ['autoreload']
       c.InteractiveShellApp.exec_lines = ['%autoreload 2']
     ``` 
      This is for auto reloading altered classes into the notebook, and making sure the working directory is always the project root.
- The exercises are available as [Jupyter Notebooks](https://docs.jupyter.org/en/latest/start/index.html), in this
project, run `jupyter notebook`. This will open a browser window in which you can navigate to the first exercise and
get started.

### Set Up Appium Inspector
Before you can use Appium Inspector, you first need to configure the capabilities. See the [Appium Inspector section in
the CONTRIBUTING.md](../CONTRIBUTING.md#example-writing-new-appium-actions) for a JSON snippet.