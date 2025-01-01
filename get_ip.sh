#!/bin/bash
IP=$(curl https://ipv4.icanhazip.com/)
echo "{\"ip\": \"$IP\"}"