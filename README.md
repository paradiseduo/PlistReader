# PlistReader
An application can read other application's plist file. Or Downgrade IPA 

# Look At Me

<img src="https://github.com/paradiseduo/PlistReader/blob/main/Image/1.PNG?raw=true" width="25%"><img src="https://github.com/paradiseduo/PlistReader/blob/main/Image/4.PNG?raw=true" width="25%"><img src="https://github.com/paradiseduo/PlistReader/blob/main/Image/2.PNG?raw=true" width="25%"><img src="https://github.com/paradiseduo/PlistReader/blob/main/Image/3.PNG?raw=true" width="25%">

<img src="https://github.com/paradiseduo/PlistReader/blob/main/Image/5.jpg?raw=true" width="33%"><img src="https://github.com/paradiseduo/PlistReader/blob/main/Image/6.jpg?raw=true" width="33%"><img src="https://github.com/paradiseduo/PlistReader/blob/main/Image/7.jpg?raw=true" width="33%">


# How to use
Just download deb and install
On Mac:
```bash
❯ iproxy 2222 22
❯ wget https://github.com/paradiseduo/PlistReader/releases/download/1.3.0/com.paradiseduo.plistreader_1.3.0_iphoneos-arm.deb
❯ scp -P 2222 com.paradiseduo.plistreader_1.3.0_iphoneos-arm.deb root@127.0.0.1:/tmp
```
On iPhone:
```bash
❯ cd /tmp
❯ dpkg -i com.paradiseduo.plistreader_1.3.0_iphoneos-arm.deb
❯ su -c /usr/bin/uicache mobile > /dev/null
```

Or use TrollStore

On root iphone
```bash
git clone https://github.com/paradiseduo/PlistReader.git
cd PlistReader
ldid -Sroot.entitlements ./PlistReader/Package/Applications/PlistReader.app/PlistReader
mkdir Payload
mv PlistReader.app Payload
zip -r app.ipa Payload
python3 -m http.server 8765
Use TrollStore install from URL http://yourip:8765/app.ipa
```

On rootless iphone
```bash
git clone https://github.com/paradiseduo/PlistReader.git
cd PlistReader
ldid -Sstore.entitlements ./PlistReader/Package/Applications/PlistReader.app/PlistReader
mkdir Payload
mv PlistReader.app Payload
zip -r app.ipa Payload
python3 -m http.server 8765
Use TrollStore install from URL http://yourip:8765/app.ipa
```

On rootless and install by root permission
```bash
git clone https://github.com/paradiseduo/PlistReader.git
cd PlistReader
ldid -Sroot.entitlements  ./PlistReader/Package/Applications/PlistReader.app/PlistReader
zip PlistReader.app PlistReader.zip
scp -P 22 PlistReader.zip mobile@10.152.102.24:/private/preboot/xxxxxx/dopamine-xxxxxx/procursus/tmp
unzip PlistReader.zip
mv PlistReader.app /private/preboot/xxxxxx/dopamine-xxxxxx/procursus/Applications
uicache -a
```


# Other
You need an jailbreak iPhone or iPad device
