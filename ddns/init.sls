#!jinja|yaml

{% from "ddns/map.jinja" import datamap with context %}

ddns_install:
  pkg:
    - installed
    - pkgs: {{ datamap.pkgs }}

{% for name, action in salt['pillar.get']('ddns:actions', {}).iteritems() %}
ddns_{{ name }}:
  ddns:
    {%- if 'absent' in action %}
    - absent
    {%- else %}
    - present
    {%- endif %}
    - name: {{ action.get('name', name) }}
    - zone: {{ action.zone }}
    - ttl: {{ action.ttl }}
    - data: {{ action.data }}
    {%- if 'rdtype' in action %}
    - rdtype: {{ action.rdtype }}
    {%- endif %}
    {%- if 'nameserver' in action %}
    - nameserver: {{ action.nameserver }}
    {%- endif %}
    {%- if 'keyfile' in action %}
    - keyfile: {{ action.keyfile }}
    {%- endif %}
    {%- if 'keyname' in action %}
    - keyname: {{ action.keyname }}
    {%- endif %}
{% endfor %}
