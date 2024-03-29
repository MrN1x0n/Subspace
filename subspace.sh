sudo apt update && sudo apt install ocl-icd-opencl-dev libopencl-clang-dev libgomp1 -y
cd $HOME
wget -O subspace-node https://github.com/subspace/subspace/releases/download/gemini-2a-2022-oct-06/subspace-node-ubuntu-x86_64-gemini-2a-2022-oct-06
wget -O subspace-farmer https://github.com/subspace/subspace/releases/download/gemini-2a-2022-oct-06/subspace-farmer-ubuntu-x86_64-gemini-2a-2022-oct-06
chmod +x subspace-node
chmod +x subspace-farmer
mv subspace-node /usr/local/bin/
mv subspace-farmer /usr/local/bin/


sudo tee /etc/systemd/system/subspace.service > /dev/null <<EOF
[Unit]
Description=Subspace Node
After=network.target

[Service]
User=$USER
Type=simple
ExecStart=/usr/local/bin/subspace-node --chain gemini-2a --execution wasm --state-pruning archive --validator --name $SUB_NODENAME
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target"
EOF

sudo tee /etc/systemd/system/subspace-farmer.service > /dev/null <<EOF
[Unit]
Description=Subspace Farmer
After=network.target

[Service]
User=$USER
Type=simple
ExecStart=/usr/local/bin/subspace-farmer farm --reward-address $SUB_WALLET --plot-size 110G
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target" 
EOF

sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable subspace subspace-farmer
sudo systemctl restart subspace subspace-farmer
