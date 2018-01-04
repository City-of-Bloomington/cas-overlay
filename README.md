City of Bloomington CAS Overlay
============================
This is a fork of the [Generic CAS Overlay](https://github.com/apereo/cas-overlay-template) project.

No alterations are done to the upstream files.  Instead, we add in Ansible deployment scripts.  Upstream changes should be able to merged in with no conflicts.  Build the WAR version normally, then use Ansible to deploy.

# Versions

```xml
<cas.version>5.2.x</cas.version>
```

# Requirements

* JDK 1.8+
* Maven 3+
* Ansible 2.4+

# Configuration

All configuration is done during deployment with Ansible.  Configuration properties should be set as variables in group_vars or host_vars.

# Build

To build the WAR file, run:

```bash
mvn clean package
```

# Deployment


Download ansible role dependencies:

```bash
cd ansible
ansible-galaxy install -r roles.yml
```

Use Ansible to deploy the built WAR file:

```
ansible-playbook deploy.yml -i /path/to/inventory
```

On a successful deployment via the following methods, CAS will be available at:

* `https://cas.server.name/cas`
