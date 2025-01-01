#!/bin/bash
IP=$(hostname -I | awk '{print $1}')
echo "{\"ip\": \"$IP\"}"