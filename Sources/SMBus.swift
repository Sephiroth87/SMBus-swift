//
//  SMBus.swift
//  SMBus-swift
//
//  Created by Fabio Ritrovato on 12/01/2016.
//  Copyright (c) 2016 orange in a day. All rights reserved.
//

import CioctlHelper
import Ci2c
import Glibc

public enum SMBusError: ErrorType {
    case OpenError
    case CloseError
    case IOError(Int32)
}

public class SMBus {
    
    
    private var fd: Int32 = -1
    private var address: Int32 = -1
    
    //MARK: Setup
    
    public init(busNumber: Int) throws {
        try open(busNumber)
    }
    
    deinit {
        _ = try? close()
    }
    
    public func open(busNumber: Int) throws {
        fd = Glibc.open("/dev/i2c-\(busNumber)", O_RDWR)
        if fd < 0 {
            throw SMBusError.OpenError
        }
    }
    
    public func close() throws {
        if fd != -1 && Glibc.close(fd) < 0 {
            throw SMBusError.CloseError
        }
        fd = -1
        address = -1
    }
    
    //MARK: Read
    
    public func readByte(address: Int32) throws -> UInt8 {
        try setAddress(address)
        let result = i2c_smbus_read_byte(fd)
        if result == -1 {
            throw SMBusError.IOError(errno)
        }
        return UInt8(truncatingBitPattern: result)
    }
    
    public func readByteData(address: Int32, command: UInt8) throws -> UInt8 {
        try setAddress(address)
        let result = i2c_smbus_read_byte_data(fd, command)
        if result == -1 {
            throw SMBusError.IOError(errno)
        }
        return UInt8(truncatingBitPattern: result)
    }
    
    public func readWordData(address: Int32, command: UInt8) throws -> UInt16 {
        try setAddress(address)
        let result = i2c_smbus_read_word_data(fd, command)
        if result == -1 {
            throw SMBusError.IOError(errno)
        }
        return UInt16(truncatingBitPattern: result)
    }
    
    //MARK: Write
    
    public func writeQuick(address: Int32) throws {
        try setAddress(address)
        let result = i2c_smbus_write_quick(fd, UInt8(I2C_SMBUS_WRITE))
        if result != 0 {
            throw SMBusError.IOError(errno)
        }
    }
    
    public func writeByte(address: Int32,  value: UInt8) throws {
        try setAddress(address)
        if i2c_smbus_write_byte(fd, value) == -1 {
            throw SMBusError.IOError(errno)
        }
    }
    
    public func writeByteData(address: Int32, command: UInt8,  value: UInt8) throws {
        try setAddress(address)
        if i2c_smbus_write_byte_data(fd, command, value) == -1 {
            throw SMBusError.IOError(errno)
        }
    }
    
    public func writeWordData(address: Int32, command: UInt8,  value: UInt16) throws {
        try setAddress(address)
        if i2c_smbus_write_word_data(fd, command, value) == -1 {
            throw SMBusError.IOError(errno)
        }
    }
    
    public func processCall(address: Int32, command: UInt8,  value: UInt16) throws {
        try setAddress(address)
        if i2c_smbus_process_call(fd, command, value) == -1 {
            throw SMBusError.IOError(errno)
        }
    }
    
    public func writeI2CBlockData(address: Int32, command: UInt8, data: [UInt8]) throws {
        try setAddress(address)
        var data = i2c_smbus_data(array: data)
        let result = i2c_smbus_access(fd, Int8(I2C_SMBUS_WRITE), command, I2C_SMBUS_I2C_BLOCK_BROKEN, &data)
        if result != 0 {
            throw SMBusError.IOError(errno)
        }
    }
    
    //MARK: Helpers
    
    private func setAddress(address: Int32) throws {
        if self.address != address {
            self.address = address
            let result = ioctl_int(fd, UInt(I2C_SLAVE), address)
            if result != 0 {
                throw SMBusError.IOError(result)
            }
        }
    }
    
}

private extension i2c_smbus_data {
    
    init(array: [UInt8]) {
        self = i2c_smbus_data()
        self.block.0 = UInt8(array.count)
        let value = { (index: Int) -> UInt8 in
            array.count > index ? array[index] : UInt8(0)
        }
        self.block.1 = value(0)
        self.block.2 = value(1)
        self.block.3 = value(2)
        self.block.4 = value(3)
        self.block.5 = value(4)
        self.block.6 = value(5)
        self.block.7 = value(6)
        self.block.8 = value(7)
        self.block.9 = value(8)
        self.block.10 = value(9)
        self.block.11 = value(10)
        self.block.12 = value(11)
        self.block.13 = value(12)
        self.block.14 = value(13)
        self.block.15 = value(14)
        self.block.16 = value(15)
        self.block.17 = value(16)
        self.block.18 = value(17)
        self.block.19 = value(18)
        self.block.20 = value(19)
        self.block.21 = value(20)
        self.block.22 = value(21)
        self.block.23 = value(22)
        self.block.24 = value(23)
        self.block.25 = value(24)
        self.block.26 = value(25)
        self.block.27 = value(26)
        self.block.28 = value(27)
        self.block.29 = value(28)
        self.block.30 = value(29)
        self.block.31 = value(30)
        self.block.32 = value(31)
    }
    
}
