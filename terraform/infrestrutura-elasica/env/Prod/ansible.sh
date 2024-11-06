#!/bin/bash
cd /home/ubuntu
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python3 get-pip.py
sudo python3 -m pip install ansible
tee -a playbook.yml > /dev/null <<EOT
- hosts: localhost
  tasks:
  - name: Instalando o python3 e virtualenv
    apt:
      pkg:
      - python3
      - virtualenv
      update_cache: yes
    become: yes
  - name: Git Clone
    ansible.builtin.git:
      repo: https://github.com/guilhermeonrails/clientes-leo-api.git
      dest: /home/ubuntu/python
      version: master
      force: yes
  - name: Instalando depedencias com pip (Django e Django Rest)
    pip:
      virtualenv: /home/ubuntu/venv
      requirements: /home/ubuntu/python/requirements.txt
  - name: Alterando o hosts do settings
    lineinfile:
      path: /home/ubuntu/python/setup/settings.py
      regexp: 'ALLOWED_HOSTS'
      line: 'ALLOWED_HOSTS = ["*"]'
      backrefs: yes
  - name: Configurando o banco de dados
    shell: '. /home/ubuntu/venv/bin/activate; python /home/ubuntu/python/manage.py migrate'
  - name: Iniciando os dados
    shell: '. /home/ubuntu/venv/bin/activate; python /home/ubuntu/python/manage.py loaddata clientes.json'
  - name: Iniciando o servidor
    shell: '. /home/ubuntu/venv/bin/activate; nohup python /home/ubuntu/python/manage.py runserver 0.0.0.0:8000 &'
EOT
ansible-playbook playbook.yml