#SMBus-swift
<a href="https://gitter.im/Sephiroth87/SMBus-swift?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge"><img src="https://badges.gitter.im/Join%20Chat.svg" alt="Join the chat at https://gitter.im/Sephiroth87/SMBus-swift" /></a>

SMBus-swift is a linux library to communicate with SMBus/I2C devices through /dev/i2c.

##Installation
The library is being written for/on a Raspberry Pi where the Package Manager is not functional yet, so I couldn't really figure out a way to make it work with that, and you'll have to do it manually for now.
After cloning, compile your program adding the 2 system dependencies and the main file, like
```
swiftc -o MyProgram -I ./SMBus-swift/Packages/Ci2c -I ./SMBus-swift/Packages/CioctlHelper ./SMBus-swift/Sources/SMBus.swift main.swift
```
You can look [here](https://github.com/Sephiroth87/scroll-phat-swift) for some examples on how to include the library in your program.

##Usage
No need to import anything since the library is built together with your other sources.
To open the connection create an SMBus object:
```
try bus = SMBus(busNumber: 1) // opens /dev/i2c-1
```
and then send your commands:
```
try bus.writeI2CBlockData(0x60, command: UInt8(0x01), values: [UInt8(2)])
```

##TODO
- [x] Add missing functions
- [ ] Add documentation
- [ ] Support Package Manager
