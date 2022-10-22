        .file   "Mcu.cpp"
#
#-------------------------------------------------------------------------------
#
        .text
.Ltext0:
        .section        .iram1,"ax",@progbits
        .literal_position
        .literal .LC0, Irq0Fired
        .align  4
#
#-------------------------------------------------------------------------------
#
        .global _Z7Dio0Irqv
        .type   _Z7Dio0Irqv, @function
_Z7Dio0Irqv:
        .file 1 "Mcu.cpp"
        entry   sp, 32
        l32r    a8, .LC0
        movi.n  a9, 1
        s8i     a9, a8, 0
        retw.n
        .size   _Z7Dio0Irqv, .-_Z7Dio0Irqv
        .literal_position
        .literal .LC1, Irq1Fired
        .align  4
        .global _Z7Dio1Irqv
        .type   _Z7Dio1Irqv, @function
_Z7Dio1Irqv:
        entry   sp, 32
        l32r    a8, .LC1
        movi.n  a9, 1
        s8i     a9, a8, 0
        retw.n
        .size   _Z7Dio1Irqv, .-_Z7Dio1Irqv
#
#-------------------------------------------------------------------------------
#
        .section        .rodata.str1.1,"aMS",@progbits,1
.LC2:
        .string "app1"
        .section        .text.getLicenseAddress,"ax",@progbits
        .literal_position
        .literal .LC3, .LC2
        .align  4
        .global getLicenseAddress
        .type   getLicenseAddress, @function
getLicenseAddress:
        entry   sp, 32
        l32r    a12, .LC3
        movi.n  a11, 0x11
        movi.n  a10, 0
        call8   esp_partition_find
        call8   esp_partition_get
        l32i.n  a8, a10, 8
        l32i.n  a2, a10, 12
        add.n   a2, a8, a2
        addmi   a2, a2, -0x1000
        retw.n
        .size   getLicenseAddress, .-getLicenseAddress
#
#-------------------------------------------------------------------------------
#
        .section        .text._Z12writelicensev,"ax",@progbits
        .literal_position
        .literal .LC4, 4096
        .literal .LC5, Codeid
        .align  4
        .global _Z12writelicensev
        .type   _Z12writelicensev, @function
_Z12writelicensev:
        entry   sp, 32
        call8   getLicenseAddress
        retw.n
        l32r    a11, .LC4
        mov.n   a2, a10
        call8   spi_flash_erase_range
        l32r    a11, .LC5
        movi.n  a12, 0x10
        mov.n   a10, a2
        call8   spi_flash_write
        retw.n
        .size   _Z12writelicensev, .-_Z12writelicensev
#
#-------------------------------------------------------------------------------
#
        .section        .text._Z11readlicensev,"ax",@progbits
        .literal_position
        .literal .LC6, Codeid
        .align  4
        .global _Z11readlicensev
        .type   _Z11readlicensev, @function
_Z11readlicensev:
        entry   sp, 32
        call8   getLicenseAddress
        l32r    a11, .LC6
        movi.n  a12, 0x10
        call8   spi_flash_read
        retw.n
        .size   _Z11readlicensev, .-_Z11readlicensev
#
#-------------------------------------------------------------------------------
#
        .section        .text._ZN8McuClassC2Ev,"ax",@progbits
        .literal_position
        .literal .LC7, 8000000
        .align  4
        .global _ZN8McuClassC2Ev
        .type   _ZN8McuClassC2Ev, @function
_ZN8McuClassC2Ev:
        entry   sp, 32
        .file 2 "e:\\documents\\arduino\\hardware\\heltec\\esp32\\libraries\\spi\\src\\spi.h"
        l32r    a8, .LC7
        s32i.n  a8, a2, 0
        movi.n  a8, 1
        s8i     a8, a2, 4
        movi.n  a8, 0
        s8i     a8, a2, 5
        movi.n  a8, 0x12
        s32i.n  a8, a2, 8
        movi.n  a8, 0xe
        s32i.n  a8, a2, 12
        movi.n  a8, 0x1a
        s32i.n  a8, a2, 16
        movi.n  a8, 0x21
        s32i.n  a8, a2, 20
        movi.n  a8, 0x50
        s16i    a8, a2, 24
        retw.n
        .size   _ZN8McuClassC2Ev, .-_ZN8McuClassC2Ev
        .global _ZN8McuClassC1Ev
        .set    _ZN8McuClassC1Ev,_ZN8McuClassC2Ev
#
#-------------------------------------------------------------------------------
#
        .section        .text._ZN8McuClass11setTimerDivEt,"ax",@progbits
        .align  4
        .global _ZN8McuClass11setTimerDivEt
        .type   _ZN8McuClass11setTimerDivEt, @function
_ZN8McuClass11setTimerDivEt:
        entry   sp, 32
        s16i    a3, a2, 24
        retw.n
        .size   _ZN8McuClass11setTimerDivEt, .-_ZN8McuClass11setTimerDivEt
#
#-------------------------------------------------------------------------------
#
        .section        .text._ZN8McuClass15setSPIFrequencyEj,"ax",@progbits
        .align  4
        .global _ZN8McuClass15setSPIFrequencyEj
        .type   _ZN8McuClass15setSPIFrequencyEj, @function
_ZN8McuClass15setSPIFrequencyEj:
        entry   sp, 32
        extui   a8, a3, 8, 8
        s8i     a3, a2, 0
        s8i     a8, a2, 1
        extui   a8, a3, 16, 8
        extui   a3, a3, 24, 8
        s8i     a3, a2, 3
        movi.n  a3, 1
        s8i     a3, a2, 4
        movi.n  a3, 0
        s8i     a8, a2, 2
        s8i     a3, a2, 5
        retw.n
        .size   _ZN8McuClass15setSPIFrequencyEj, .-_ZN8McuClass15setSPIFrequencyEj
#
#-------------------------------------------------------------------------------
#
        .section        .text._ZN8McuClass14singleTransferEth,"ax",@progbits
        .literal_position
        .literal .LC8, SPI
        .align  4
        .global _ZN8McuClass14singleTransferEth
        .literal .newsingleTransfer, _ZN8McuClass14singleTransferEth
        .type   _ZN8McuClass14singleTransferEth, @function
_ZN8McuClass14singleTransferEth:
        entry   sp, 32
        l8ui    a10, a2, 8
        movi.n  a11, 0
        call8   digitalWrite
        l32r    a5, .LC8
        l32i.n  a12, a2, 4
        l32i.n  a11, a2, 0
        mov.n   a10, a5
        call8   _ZN8SPIClass16beginTransactionE11SPISettings
        extui   a3, a3, 0, 16
        extui   a11, a3, 0, 8
        mov.n   a10, a5
        call8   _ZN8SPIClass8transferEh
        extui   a4, a4, 0, 8
        mov.n   a11, a4
        mov.n   a10, a5
        call8   _ZN8SPIClass8transferEh
        mov.n   a3, a10
        mov.n   a10, a5
        call8   _ZN8SPIClass14endTransactionEv
        l8ui    a10, a2, 8
        movi.n  a11, 1
        call8   digitalWrite
        mov.n   a2, a3
        retw.n
        .size   _ZN8McuClass14singleTransferEth, .-_ZN8McuClass14singleTransferEth
#
#-------------------------------------------------------------------------------
#
        .section        .text._ZN8McuClass12readRegisterEt,"ax",@progbits
        .align  4
        .global _ZN8McuClass12readRegisterEt
        .literal .newReadRegister, _ZN8McuClass12readRegisterEt

        .global vsnprintf
        .literal .newvsnprintf, vsnprintf

        .type   _ZN8McuClass12readRegisterEt, @function
_ZN8McuClass12readRegisterEt:
        entry   sp, 32
        movi.n  a12, 0
        extui   a11, a3, 0, 7
        mov.n   a10, a2
        l32r a8, .newsingleTransfer
        callx8  a8
        mov.n   a2, a10
        retw.n
        .size   _ZN8McuClass12readRegisterEt, .-_ZN8McuClass12readRegisterEt
#
#-------------------------------------------------------------------------------
#
        .section        .text._ZN8McuClass13writeRegisterEth,"ax",@progbits
        .align  4
        .global _ZN8McuClass13writeRegisterEth
        .literal .newWriteRegister, _ZN8McuClass13writeRegisterEth
        .type   _ZN8McuClass13writeRegisterEth, @function
_ZN8McuClass13writeRegisterEth:
        entry   sp, 32
        extui   a11, a3, 0, 16
        movi    a8, 0x80
        extui   a12, a4, 0, 8
        or      a11, a11, a8
        mov.n   a10, a2
        l32r a8, .newsingleTransfer
        callx8  a8
        retw.n
        .size   _ZN8McuClass13writeRegisterEth, .-_ZN8McuClass13writeRegisterEth
#
#-------------------------------------------------------------------------------
#
        .section        .text._ZN8McuClass10writefifo0EtPhh,"ax",@progbits
        .literal_position
        .literal .LC11, SPI
        .align  4
        .global _ZN8McuClass10writefifo0EtPhh
        .type   _ZN8McuClass10writefifo0EtPhh, @function
_ZN8McuClass10writefifo0EtPhh:
        entry   sp, 32
        l8ui    a10, a2, 8
        movi.n  a11, 0
        call8   digitalWrite
        l32r    a6, .LC11
        l32i.n  a11, a2, 0
        l32i.n  a12, a2, 4
        mov.n   a10, a6
        call8   _ZN8SPIClass16beginTransactionE11SPISettings
        extui   a3, a3, 0, 16
        extui   a5, a5, 0, 8
        extui   a11, a3, 0, 8
        mov.n   a10, a6
        call8   _ZN8SPIClass8transferEh
        add.n   a5, a4, a5
.L14:
        beq     a4, a5, .L13
        l8ui    a11, a4, 0
        mov.n   a10, a6
        call8   _ZN8SPIClass8transferEh
        addi.n  a4, a4, 1
        j       .L14
.L13:
        mov.n   a10, a6
        call8   _ZN8SPIClass14endTransactionEv
        l8ui    a10, a2, 8
        movi.n  a11, 1
        call8   digitalWrite
        retw.n
        .size   _ZN8McuClass10writefifo0EtPhh, .-_ZN8McuClass10writefifo0EtPhh
#
#-------------------------------------------------------------------------------
#
        .section        .text._ZN8McuClass9readfifo0EtPhh,"ax",@progbits
        .literal_position
        .literal .LC12, SPI
        .align  4
        .global _ZN8McuClass9readfifo0EtPhh
        .type   _ZN8McuClass9readfifo0EtPhh, @function
_ZN8McuClass9readfifo0EtPhh:
        entry   sp, 32
        l8ui    a10, a2, 8
        movi.n  a11, 0
        call8   digitalWrite
        l32r    a6, .LC12
        l32i.n  a11, a2, 0
        l32i.n  a12, a2, 4
        mov.n   a10, a6
        call8   _ZN8SPIClass16beginTransactionE11SPISettings
        extui   a3, a3, 0, 16
        extui   a5, a5, 0, 8
        extui   a11, a3, 0, 8
        mov.n   a10, a6
        call8   _ZN8SPIClass8transferEh
        add.n   a5, a4, a5
.L17:
        beq     a4, a5, .L16
        movi.n  a11, 0
        mov.n   a10, a6
        call8   _ZN8SPIClass8transferEh
        s8i     a10, a4, 0
        addi.n  a4, a4, 1
        j       .L17
.L16:
        mov.n   a10, a6
        call8   _ZN8SPIClass14endTransactionEv
        l8ui    a10, a2, 8
        movi.n  a11, 1
        call8   digitalWrite
        retw.n
        .size   _ZN8McuClass9readfifo0EtPhh, .-_ZN8McuClass9readfifo0EtPhh
#
#-------------------------------------------------------------------------------
#
        .section        .text.write0,"ax",@progbits
        .literal_position
        .literal .LC13, Mcu
        .align  4
        .global write0
        .type   write0, @function
write0:
        entry   sp, 32
        l32r    a10, .LC13
        extui   a12, a3, 0, 8
        extui   a11, a2, 0, 16
        l32r a8, .newWriteRegister
        callx8  a8
        retw.n
        .size   write0, .-write0
#
#-------------------------------------------------------------------------------
#
        .section        .text.read0,"ax",@progbits
        .literal_position
        .literal .LC14, Mcu
        .align  4
        .global read0
        .type   read0, @function
read0:
        entry   sp, 32
        l32r    a10, .LC14
        extui   a11, a2, 0, 16
        l32r a8, .newReadRegister
        callx8  a8
        mov.n   a2, a10
        retw.n
        .size   read0, .-read0
#
#-------------------------------------------------------------------------------
#
        .section        .text.writefifo,"ax",@progbits
        .literal_position
        .literal .LC15, Mcu
        .align  4
        .global writefifo
        .type   writefifo, @function
writefifo:
        entry   sp, 32
        l32r    a10, .LC15
        extui   a13, a4, 0, 8
        mov.n   a12, a3
        extui   a11, a2, 0, 16
        call8   _ZN8McuClass10writefifo0EtPhh
        retw.n
        .size   writefifo, .-writefifo
#
#-------------------------------------------------------------------------------
#
        .section        .text.readfifo,"ax",@progbits
        .literal_position
        .literal .LC16, Mcu
        .align  4
        .global readfifo
        .type   readfifo, @function
readfifo:
        entry   sp, 32
        l32r    a10, .LC16
        extui   a13, a4, 0, 8
        mov.n   a12, a3
        extui   a11, a2, 0, 16
        call8   _ZN8McuClass9readfifo0EtPhh
        retw.n
        .size   readfifo, .-readfifo
#
#-------------------------------------------------------------------------------
#
        .section        .text.timercheck,"ax",@progbits
        .literal_position
        .literal .LC17, ESP
        .literal .LC18, -404620549, 34243
        .align  4
        .global timercheck
        .type   timercheck, @function
timercheck:
        entry   sp, 32
        l32r    a10, .LC17
        movi.n  a3, 1
        call8   _ZN8EspClass11getEfuseMacEv
        l32r    a8, .LC18
        l32r    a9, .LC18+4
        add.n   a2, a10, a8
        bltu    a2, a10, .L23
        movi.n  a3, 0
.L23:
        add.n   a11, a11, a9
        add.n   a3, a3, a11
        retw.n
        .size   timercheck, .-timercheck
#
#-------------------------------------------------------------------------------
#
        .section        .text._ZN8McuClass6calrtcEv,"ax",@progbits
        .literal_position
        .literal .LC19, TimeSwitch
        .literal .LC20, 0x08000000
        .literal .LC21, 0x7fffffff
        .literal .LC22, ESP
        .literal .LC23, 0xffff0000
        .literal .LC24, 0x7f94c959
        .literal .LC25, 0x0f0f0f0f
        .literal .LC26, 0xf0f0f0f0
        .literal .LC27, 0x0a4e384e
        .literal .LC28, 0x33333333
        .literal .LC29, 0xcccccccc
        .literal .LC30, 0x572384dc
        .literal .LC31, 0x55555555
        .literal .LC32, 0xaaaaaaaa
        .literal .LC34, 0x00ff00ff
        .literal .LC35, 0xff00ff00
        .literal .LC36, Codeid
        .literal .LC37, 0x80000000
        .literal .LC38, 0x04000000
        .literal .LC39, 0xbfffffff
        .literal .LC40, 0x181e0505, 0xffff7a3c
        .literal .LC41, 0xfff0ffff
        .literal .LC42, 0x000f0000
        .literal .LC43, 0x394bbd41
        .literal .LC44, 0x3facf646
        .literal .LC45, 0x414de9da
        .literal .LC46, 0x7e799942
        .literal .LC47, 0x40000000
        .literal .LC48, 0x02000000
        .literal .LC49, 0xdfffffff
        .literal .LC50, 0xf0ffff0f
        .literal .LC51, 0x0f000000
        .literal .LC52, 0xb2f6b12d
        .literal .LC53, 0x1bedc3b2
        .literal .LC54, 0xf5941f73
        .literal .LC55, 0x73e9aedb
        .literal .LC56, 0x20000000
        .literal .LC57, 0x01000000
        .literal .LC58, 0xefffffff
        .literal .LC59, 0xfffff0ff
        .literal .LC60, 0x00000f00
        .literal .LC61, 0x237ce438
        .literal .LC62, 0xd9c7de39
        .literal .LC63, 0x41ec0f9a
        .literal .LC64, 0x28c6c100
        .literal .LC65, 0x10000000
        .align  4
        .global _ZN8McuClass6calrtcEv
        .type   _ZN8McuClass6calrtcEv, @function
_ZN8McuClass6calrtcEv:
        entry   sp, 32
        l32r    a2, .LC19
        l32r    a8, .LC20
        l32i.n  a10, a2, 0
        and     a3, a10, a8
        bnez.n  a3, .L26
#
        l32r    a9, .LC21
        and     a9, a10, a9
        l32r    a10, .LC22
        or      a8, a9, a8
        s32i.n  a8, a2, 0
        call8   _ZN8EspClass11getEfuseMacEv
        slli    a8, a11, 16
        extui   a9, a10, 16, 16
        or      a9, a8, a9
        l32r    a8, .LC23
        and     a9, a9, a8
        add.n   a10, a9, a10
        movi.n  a8, 1
        bltu    a10, a9, .L27
        mov.n   a8, a3
.L27:
        add.n   a8, a8, a11
        extui   a11, a11, 0, 16
        sub     a11, a10, a11
        movi.n  a3, 1
        bltu    a10, a11, .L28
        movi.n  a3, 0
.L28:
        sub     a8, a8, a3
        slli    a8, a8, 16
        extui   a11, a11, 16, 16
        or      a11, a8, a11
        l32r    a8, .LC24
        l32r    a10, .LC26
        add.n   a11, a11, a8
        l32r    a8, .LC25
        srli    a3, a11, 4
        slli    a11, a11, 4
        and     a8, a3, a8
        and     a11, a11, a10
        l32r    a9, .LC27
        or      a8, a8, a11
        add.n   a8, a8, a9
        l32r    a10, .LC29
        l32r    a9, .LC28
        srli    a3, a8, 2
        slli    a8, a8, 2
        and     a8, a8, a10
        and     a9, a3, a9
        l32r    a3, .LC30
        or      a9, a9, a8
        add.n   a9, a9, a3
        l32r    a10, .LC31
        srli    a8, a9, 1
        and     a8, a8, a10
        slli    a10, a9, 1
        l32r    a9, .LC32
        and     a9, a10, a9
        or      a8, a8, a9
        sub     a8, a8, a3
        l32r    a9, .LC34
        srli    a10, a8, 8
        and     a10, a10, a9
        l32r    a3, .LC36
        l32r    a9, .LC35
        slli    a8, a8, 8
        and     a8, a8, a9
        l32i.n  a3, a3, 0
        or      a8, a10, a8
        bne     a8, a3, .L26
        l32i.n  a3, a2, 0
        l32r    a8, .LC37
        or      a8, a3, a8
        s32i.n  a8, a2, 0
.L26:
        l32i.n  a10, a2, 0
        l32r    a8, .LC38
        and     a3, a10, a8
        bnez.n  a3, .L31
        l32r    a9, .LC39
        and     a9, a10, a9
        or      a8, a9, a8
        s32i.n  a8, a2, 0
        call8   timercheck
        l32r    a12, .LC40
        l32r    a13, .LC40+4
        add.n   a9, a10, a12
        movi.n  a8, 1
        bltu    a9, a10, .L32
        mov.n   a8, a3
.L32:
        add.n   a11, a11, a13
        add.n   a8, a8, a11
        l32r    a10, .LC23
        extui   a11, a9, 16, 16
        slli    a3, a8, 16
        or      a11, a3, a11
        and     a11, a11, a10
        add.n   a10, a11, a9
        movi.n  a9, 1
        bltu    a10, a11, .L33
        movi.n  a9, 0
.L33:
        add.n   a9, a9, a8
        extui   a8, a8, 0, 16
        sub     a8, a10, a8
        movi.n  a3, 1
        bltu    a10, a8, .L34
        movi.n  a3, 0
.L34:
        sub     a9, a9, a3
        slli    a9, a9, 16
        extui   a10, a8, 16, 16
        or      a10, a9, a10
        l32r    a9, .LC41
        slli    a8, a8, 4
        and     a10, a10, a9
        l32r    a9, .LC42
        l32r    a11, .LC29
        and     a8, a8, a9
        l32r    a9, .LC43
        or      a8, a8, a10
        add.n   a9, a8, a9
        l32r    a10, .LC35
        l32r    a8, .LC34
        srli    a3, a9, 8
        slli    a9, a9, 8
        and     a8, a3, a8
        and     a9, a9, a10
        or      a9, a8, a9
        l32r    a8, .LC44
        movi.n  a10, -1
        add.n   a8, a9, a8
        srli    a3, a8, 2
        l32r    a9, .LC28
        xor     a8, a10, a8
        slli    a8, a8, 2
        and     a9, a3, a9
        and     a8, a8, a11
        or      a8, a9, a8
        l32r    a9, .LC45
        l32r    a11, .LC26
        add.n   a9, a8, a9
        xor     a10, a10, a9
        l32r    a8, .LC25
        srli    a10, a10, 4
        slli    a9, a9, 4
        and     a10, a10, a8
        and     a9, a9, a11
        l32r    a8, .LC46
        or      a9, a10, a9
        add.n   a8, a9, a8
        l32r    a9, .LC31
        srli    a10, a8, 1
        and     a10, a10, a9
        l32r    a3, .LC36
        l32r    a9, .LC32
        slli    a8, a8, 1
        and     a8, a8, a9
        l32i.n  a3, a3, 4
        or      a8, a10, a8
        bne     a8, a3, .L31
        l32i.n  a3, a2, 0
        l32r    a8, .LC47
        or      a8, a3, a8
        s32i.n  a8, a2, 0
.L31:
        l32i.n  a10, a2, 0
        l32r    a8, .LC48
        and     a3, a10, a8
        bnez.n  a3, .L37
        l32r    a9, .LC49
        and     a9, a10, a9
        or      a8, a9, a8
        s32i.n  a8, a2, 0
        call8   timercheck
        l32r    a12, .LC40
        l32r    a13, .LC40+4
        add.n   a9, a10, a12
        movi.n  a8, 1
        bltu    a9, a10, .L38
        mov.n   a8, a3
.L38:
        add.n   a11, a11, a13
        add.n   a8, a8, a11
        l32r    a10, .LC23
        extui   a11, a9, 16, 16
        slli    a3, a8, 16
        or      a11, a3, a11
        and     a11, a11, a10
        add.n   a10, a11, a9
        movi.n  a9, 1
        bltu    a10, a11, .L39
        movi.n  a9, 0
.L39:
        add.n   a9, a9, a8
        extui   a8, a8, 0, 16
        sub     a8, a10, a8
        movi.n  a3, 1
        bltu    a10, a8, .L40
        movi.n  a3, 0
.L40:
        sub     a9, a9, a3
        slli    a9, a9, 16
        extui   a11, a8, 16, 16
        or      a11, a9, a11
        l32r    a9, .LC50
        l32r    a10, .LC51
        and     a11, a11, a9
        slli    a9, a8, 16
        and     a9, a9, a10
        movi    a10, 0xf0
        or      a9, a11, a9
        and     a8, a8, a10
        or      a8, a8, a9
        l32r    a9, .LC52
        movi.n  a11, -1
        add.n   a8, a8, a9
        xor     a9, a11, a8
        l32r    a10, .LC35
        l32r    a12, .LC34
        srli    a9, a9, 8
        slli    a8, a8, 8
        and     a9, a9, a12
        and     a8, a8, a10
        or      a10, a9, a8
        l32r    a9, .LC53
        l32r    a8, .LC25
        add.n   a9, a10, a9
        srli    a3, a9, 4
        l32r    a10, .LC26
        xor     a9, a11, a9
        slli    a9, a9, 4
        and     a9, a9, a10
        and     a8, a3, a8
        or      a8, a8, a9
        l32r    a9, .LC54
        l32r    a3, .LC36
        add.n   a8, a8, a9
        xor     a8, a11, a8
        l32r    a9, .LC28
        srli    a10, a8, 2
        and     a10, a10, a9
        l32r    a9, .LC29
        slli    a8, a8, 2
        and     a8, a8, a9
        l32r    a9, .LC55
        or      a8, a10, a8
        add.n   a8, a8, a9
        l32r    a9, .LC31
        srli    a10, a8, 1
        and     a10, a10, a9
        l32r    a9, .LC32
        slli    a8, a8, 1
        and     a8, a8, a9
        l32i.n  a3, a3, 8
        or      a8, a10, a8
        bne     a8, a3, .L37
        l32i.n  a3, a2, 0
        l32r    a8, .LC56
        or      a8, a3, a8
        s32i.n  a8, a2, 0
.L37:
        l32i.n  a10, a2, 0
        l32r    a8, .LC57
        and     a3, a10, a8
        bnez.n  a3, .L24
        l32r    a9, .LC58
        and     a9, a10, a9
        or      a8, a9, a8
        s32i.n  a8, a2, 0
        call8   timercheck
        l32r    a12, .LC40
        l32r    a13, .LC40+4
        add.n   a9, a10, a12
        movi.n  a8, 1
        bltu    a9, a10, .L44
        mov.n   a8, a3
.L44:
        add.n   a11, a11, a13
        add.n   a8, a8, a11
        l32r    a10, .LC23
        extui   a11, a9, 16, 16
        slli    a3, a8, 16
        or      a11, a3, a11
        and     a11, a11, a10
        add.n   a10, a11, a9
        movi.n  a9, 1
        bltu    a10, a11, .L45
        movi.n  a9, 0
.L45:
        add.n   a9, a9, a8
        extui   a8, a8, 0, 16
        sub     a8, a10, a8
        movi.n  a11, 1
        bltu    a10, a8, .L46
        movi.n  a11, 0
.L46:
        sub     a11, a9, a11
        slli    a11, a11, 16
        extui   a10, a8, 16, 16
        l32r    a9, .LC59
        or      a10, a11, a10
        and     a9, a10, a9
        l32r    a10, .LC60
        slli    a8, a8, 8
        and     a8, a8, a10
        movi.n  a11, -1
        or      a10, a8, a9
        xor     a9, a11, a10
        l32r    a8, .LC31
        srli    a9, a9, 1
        and     a9, a9, a8
        l32r    a8, .LC32
        slli    a10, a10, 1
        and     a10, a10, a8
        or      a10, a9, a10
        l32r    a9, .LC61
        l32r    a8, .LC25
        add.n   a9, a10, a9
        srli    a10, a9, 4
        and     a10, a10, a8
        xor     a9, a11, a9
        l32r    a8, .LC26
        slli    a9, a9, 4
        and     a9, a9, a8
        or      a9, a10, a9
        l32r    a10, .LC62
        l32r    a3, .LC36
        add.n   a9, a9, a10
        xor     a8, a11, a9
        l32r    a10, .LC34
        srli    a8, a8, 8
        and     a8, a8, a10
        l32r    a10, .LC35
        slli    a9, a9, 8
        and     a9, a9, a10
        or      a8, a8, a9
        l32r    a9, .LC63
        l32i.n  a3, a3, 12
        add.n   a8, a8, a9
        xor     a8, a11, a8
        l32r    a9, .LC28
        srli    a10, a8, 2
        and     a10, a10, a9
        l32r    a9, .LC29
        slli    a8, a8, 2
        and     a8, a8, a9
        l32r    a9, .LC64
        or      a8, a10, a8
        add.n   a8, a8, a9
        bne     a8, a3, .L24
        l32i.n  a3, a2, 0
        l32r    a8, .LC65
        or      a8, a3, a8
        s32i.n  a8, a2, 0
.L24:
        retw.n
        .size   _ZN8McuClass6calrtcEv, .-_ZN8McuClass6calrtcEv
#
#-------------------------------------------------------------------------------
#
        .section        .text.calRTC,"ax",@progbits
        .literal_position
        .literal .LC66, Mcu
        .align  4
        .global calRTC
        .type   calRTC, @function
calRTC:
        entry   sp, 32
        l32r    a10, .LC66
        call8   _ZN8McuClass6calrtcEv
        retw.n
        .size   calRTC, .-calRTC
#
#-------------------------------------------------------------------------------
#
        .section        .text.startup._GLOBAL__sub_I_timer,"ax",@progbits
        .literal_position
        .literal .LC67, _ZL11INADDR_NONE
        .literal .LC68, Mcu
        .align  4
        .type   _GLOBAL__sub_I_timer, @function
_GLOBAL__sub_I_timer:
        entry   sp, 32
        .file 3 "e:\\documents\\arduino\\hardware\\heltec\\esp32\\cores\\esp32\\IPAddress.h"
        movi.n  a14, 0
        l32r    a10, .LC67
        mov.n   a13, a14
        mov.n   a12, a14
        mov.n   a11, a14
        call8   _ZN9IPAddressC1Ehhhh
        l32r    a10, .LC68
        call8   _ZN8McuClassC1Ev
        retw.n
        .size   _GLOBAL__sub_I_timer, .-_GLOBAL__sub_I_timer
#
#-------------------------------------------------------------------------------
#
        .section        .ctors,"aw",@progbits
        .align  4
        .word   _GLOBAL__sub_I_timer
        .section        .text.exit._GLOBAL__sub_D_timer,"ax",@progbits
        .align  4
        .type   _GLOBAL__sub_D_timer, @function
_GLOBAL__sub_D_timer:
        entry   sp, 32
        retw.n
        .size   _GLOBAL__sub_D_timer, .-_GLOBAL__sub_D_timer
#
#-------------------------------------------------------------------------------
#
        .section        .rodata.str1.1
.LC73:
        .string "AT+CDKEY="
        .section        .text._Z18getlicensefromuartv,"ax",@progbits
        .literal_position
        .literal .LC71, __stack_chk_guard
        .literal .LC72, Serial
        .literal .LC74, .LC73
        .literal .LC75, Codeid
        .align  4
        .global _Z18getlicensefromuartv
        .type   _Z18getlicensefromuartv, @function
_Z18getlicensefromuartv:
        entry   sp, 128
        l32r    a3, .LC71
        movi    a6, 0xc7
        memw
        l32i.n  a2, a3, 0
        memw
        s32i    a2, sp, 92
        call8   millis
        mov.n   a5, a10
        movi.n  a2, 0
.L54:
        call8   millis
        sub     a10, a10, a5
        bltu    a6, a10, .L52
        l32r    a4, .LC72
        mov.n   a10, a4
        call8   _ZN14HardwareSerial9availableEv
        blti    a10, 1, .L53
        mov.n   a10, a4
        addi    a4, sp, 42
        addi.n  a7, a2, 1
        call8   _ZN14HardwareSerial4readEv
        add.n   a2, a4, a2
        s8i     a10, a2, 0
        mov.n   a2, a7
.L53:
        movi.n  a4, 0x31
        bne     a2, a4, .L54
.L56:
        movi.n  a2, 0
        j       .L55
.L52:
        movi.n  a4, 0x29
        bne     a2, a4, .L56
        l32r    a11, .LC74
        movi.n  a12, 0xa
        mov.n   a10, sp
        call8   memcpy
        movi.n  a2, 0
        movi.n  a8, 9
        loop    a8, .L57_LEND
.L57:
        addi    a4, sp, 0
        add.n   a9, a4, a2
        addi    a4, sp, 42
        l8ui    a10, a9, 0
        add.n   a9, a4, a2
        l8ui    a4, a9, 0
        bne     a10, a4, .L56
        addi.n  a2, a2, 1
        .L57_LEND:
        addi.n  a8, sp, 10
        addi    a2, sp, 42
        mov.n   a12, a8
        movi    a4, 0x60
        movi.n  a11, 0x39
        movi.n  a10, 0x20
        loop    a10, .L62_LEND
.L62:
        l8ui    a9, a2, 9
        bltu    a4, a9, .L58
        j       .L71
.L58:
        addi    a9, a9, -32
.L71:
        s8i     a9, a8, 0
        l8ui    a9, a8, 0
        bltu    a11, a9, .L60
        addi    a9, a9, -48
        j       .L72
.L60:
        addi    a9, a9, -55
.L72:
        s8i     a9, a8, 0
        addi.n  a2, a2, 1
        addi.n  a8, a8, 1
        .L62_LEND:
        l32r    a8, .LC75
        movi.n  a2, 0
.L64:
        add.n   a13, a12, a2
        movi.n  a11, 0x1c
        movi.n  a9, 0
        movi.n  a10, 8
        loop    a10, .L63_LEND
.L63:
        l8ui    a14, a13, 0
        addi.n  a13, a13, 1
        ssl     a11
        sll     a14, a14
        or      a9, a9, a14
        addi    a11, a11, -4
        .L63_LEND:
        s32i.n  a9, a8, 0
        addi.n  a2, a2, 8
        addi.n  a8, a8, 4
        bnei    a2, 32, .L64
        call8   _Z12writelicensev
        movi.n  a2, 1
.L55:
        memw
        l32i    a4, sp, 92
        memw
        l32i.n  a3, a3, 0
        beq     a4, a3, .L65
        call8   __stack_chk_fail
.L65:
        retw.n
        .size   _Z18getlicensefromuartv, .-_Z18getlicensefromuartv
#
#-------------------------------------------------------------------------------
#
        .section        .text.lora_printf,"ax",@progbits
        .literal_position
        .literal .LC76, __stack_chk_guard
        .literal .LC77, Serial
        .align  4
        .global lora_printf
        .type   lora_printf, @function
lora_printf:
        entry   sp, 160
        s32i.n  a3, sp, 4
        l32r    a3, .LC76
        s32i.n  a5, sp, 12
        s32i.n  a4, sp, 8
        s32i.n  a6, sp, 16
        s32i.n  a7, sp, 20
        memw
        l32i.n  a4, a3, 0
        movi.n  a11, 0
        memw
        s32i    a4, sp, 124
        addi    a4, sp, 0
        s32i.n  a4, sp, 40
        movi    a4, 0x80
        add.n   a13, sp, a4
        movi.n  a15, 4
        addi    a4, sp, 0
        mov.n   a14, sp
        mov.n   a12, a2
        mov.n   a10, a11
        s32i.n  a4, sp, 52
        s32i.n  a13, sp, 36
        s32i.n  a15, sp, 44
        s32i.n  a13, sp, 48
        s32i.n  a15, sp, 56
        l32r a8, .newvsnprintf
        callx8  a8
        movi.n  a8, 0x3f
        mov.n   a5, a3
        addi.n  a4, a10, 1
        addi    a3, sp, 60
        bgeu    a8, a10, .L74
        mov.n   a10, a4
        call8   _Znaj
        mov.n   a3, a10
.L74:
        l32i.n  a13, sp, 36
        l32i.n  a14, sp, 40
        l32i.n  a15, sp, 44
        mov.n   a12, a2
        mov.n   a11, a4
        mov.n   a10, a3
        l32r a8, .newvsnprintf
        callx8  a8
        mov.n   a12, a10
        mov.n   a2, a10
        l32r    a10, .LC77
        mov.n   a11, a3
        movi.n  a4, 0x40
        call8   _ZN14HardwareSerial5writeEPKhj
        bgeu    a4, a2, .L73
        mov.n   a10, a3
        call8   _ZdaPv
.L73:
        memw
        l32i    a3, sp, 124
        memw
        l32i.n  a2, a5, 0
        beq     a3, a2, .L76
        call8   __stack_chk_fail
.L76:
        retw.n
        .size   lora_printf, .-lora_printf
#
#-------------------------------------------------------------------------------
#
        .section        .rodata.str1.1
.LC81:
        .string "ESP32 MCU init...\r\n"
.LC86:
        .string "The board ID is "
.LC88:
        .string "%04X%08X\r\n"
.LC90:
        .string "Please provide a correct license! For more information:\r\n"
.LC92:
        .string "http://www.heltec.cn/search/\r\n"
.LC94:
        .string "ESP32 MCU inited OK!\r\n"
#
        .section        .text._ZN8McuClass4initEiiiiPj,"ax",@progbits
        .literal_position
        .literal .LC79, mcuStarted
        .literal .LC80, TimeSwitch
        .literal .LC82, .LC81 # "ESP32 MCU init...\r\n"
        .literal .LC83, -16777216 # 0xff000000
        .literal .LC84, Codeid
        .literal .LC85, ESP
        .literal .LC87, .LC86 # "The board ID is "
        .literal .LC89, .LC88 # "%04X%08X\r\n"
        .literal .LC91, .LC90 # "Please provide a correct license! For more information:\r\n"
        .literal .LC93, .LC92 # "http://www.heltec.cn/search/\r\n"
        .literal .LC95, .LC94 # "ESP32 MCU inited OK!\r\n"
        .literal .LC96, _Z7Dio0Irqv
        .literal .LC97, _Z7Dio1Irqv
        .literal .LC98, timer
        .literal .LC99, TimerIrqHandler
        .literal .LC100, factory_test
        .literal .LC101, 80000
        .literal .LC102, -268435456
        .align  4
        .global _ZN8McuClass4initEiiiiPj
        .type   _ZN8McuClass4initEiiiiPj, @function
#
# a3 - Select line
# a4 - Reset line (stored to SP + 20)
# a5 - DIO0 (stored to SP + 24)
# a6 - DIO1 (stored to SP + 28)
# a7 - License pointer (stored to SP + 12)
#
_ZN8McuClass4initEiiiiPj:
        entry   sp, 64
        s32i.n  a6, sp, 28
        l32r    a6, .LC79       # mcuStarted pointer
        s32i.n  a5, sp, 24
        l8ui    a5, a6, 0       # Get mcuStarted value
        s32i.n  a4, sp, 20
        bnez.n  a5, .L79        # If mcuStarted != 0, skip
#
        l32r    a4, .LC80       # TimeSwitch pointer
        l32r    a10, .LC82
        s32i.n  a5, a4, 0       # TimeSwitch = 0
        s32i.n  a7, sp, 12
        call8   lora_printf     # Print "ESP32 MCU init...\r\n"
#
        call8   _Z11readlicensev
        mov.n   a10, a2
        call8   _ZN8McuClass6calrtcEv
        l32i.n  a10, a4, 0
        l32r    a9, .LC83       # a9 = 0xff000000
        mov.n   a7, a4
        and     a10, a10, a9
        l32i.n  a11, sp, 12     # Get pointer to license
        beq     a10, a9, .L81
#
#  Copy license (16 bytes) to Codeid
#
        s32i.n  a5, a4, 0
        l32i.n  a12, a11, 0
        l32r    a10, .LC84      # Pointer to Codeid
        s32i.n  a12, a10, 0
        l32i.n  a12, a11, 4
        s32i.n  a12, a10, 4
        l32i.n  a12, a11, 8
        s32i.n  a12, a10, 8
        l32i.n  a11, a11, 12
        s32i.n  a11, a10, 12
#
        mov.n   a10, a2
        s32i.n  a9, sp, 16
        call8   _ZN8McuClass6calrtcEv
        l32i.n  a8, a4, 0
        l32i.n  a9, sp, 16
        and     a8, a8, a9
        bne     a8, a9, .L82    # License key no good, go complain
#
        call8   _Z12writelicensev
        j       .L81
#
#  When the license key is invalid
#
.L82:
        l32r    a10, .LC85      # pointer to ESP
        call8   _ZN8EspClass11getEfuseMacEv
        mov.n   a12, a10
        l32r    a10, .LC87
        s32i.n  a11, sp, 12
        s32i.n  a12, sp, 16
        call8   lora_printf     # Print "The board ID is "
        l32i.n  a12, sp, 16
        l32i.n  a11, sp, 12
        l32r    a10, .LC89
        call8   lora_printf     # Print "%04X%08X\r\n"
        l32r    a10, .LC91
        call8   lora_printf     # Print "Please provide a correct license! For more information:\r\n"
        l32r    a10, .LC93
        call8   lora_printf     # Print "http://www.heltec.cn/search/\r\n"
#
#  Apparently sends "AT+CDKEY=?" to something and loops until it gets a response
#
.L84:
        s32i.n  a5, a7, 0
        call8   _Z18getlicensefromuartv
        call8   _Z11readlicensev
        mov.n   a10, a2
        call8   _ZN8McuClass6calrtcEv
        l32i.n  a8, a7, 0
        l32r    a9, .LC83       # a9 = 0xff000000
        and     a8, a8, a9
        bne     a8, a9, .L84
        j       .L81
#
#  When mcuStarted == 1
#
.L79:
        mov.n   a10, a2
        call8   _ZN8McuClass6calrtcEv
#
#  If mcuStarted != 0, initialize pins, etc. If it 0, then check the TimeSwitch
#  variable see if we should wake up or just go back to sleep.
#
.L81:
        l8ui    a5, a6, 0       # Get mcuStarted value
        bnez.n  a5, .L85        # If not 0 then skip sleep check
#
        movi.n  a5, 1           # Non-zero value
        s8i     a5, a6, 0       # Set mcuStarted = 1
#
#  Check if TimeSwitch set or not (external RTC board?)
#
        l32r    a5, .LC80       # Pointer to TimeSwitch
        l32r    a6, .LC83       # a6 = 0xff000000
        l32i.n  a5, a5, 0       # Load TimeSwitch value
        and     a5, a5, a6      # And with 0xff000000
        bne     a5, a6, .L86    # If not 0xff000000 then go to sleep
#
        l32r    a10, .LC95
        call8   lora_printf     # Print "ESP32 MCU inited OK!\r\n"
        j       .L85
#
#  Enter deep sleep mode. RTC will wake us up by resetting us
#
.L86:
        movi    a10, 0x64
        call8   delay
        call8   esp_deep_sleep_start
#
#  Initialize pins to talk to SX1276, attach interrupts, start timer
#
.L85:
        l32i.n  a4, sp, 20
        s32i.n  a3, a2, 8
        s32i.n  a4, a2, 12
        l32i.n  a4, sp, 24
        extui   a10, a3, 0, 8
        s32i.n  a4, a2, 16
        l32i.n  a4, sp, 28
        movi.n  a11, 2
        s32i.n  a4, a2, 20
        call8   pinMode
        l8ui    a10, a2, 12
        movi.n  a11, 2
        call8   pinMode
        l8ui    a10, a2, 12
        movi.n  a11, 1
        call8   digitalWrite
        movi.n  a10, 0x14
        call8   delay
        l8ui    a10, a2, 12
        movi.n  a11, 0
        call8   digitalWrite
        movi.n  a10, 0x14
        call8   delay
        l8ui    a10, a2, 12
        movi.n  a11, 1
        call8   digitalWrite
        movi.n  a10, 0x14
        call8   delay
        l8ui    a10, a2, 16
        movi.n  a11, 9
        call8   pinMode
        l8ui    a10, a2, 20
        movi.n  a11, 9
        call8   pinMode
        l8ui    a10, a2, 16
        l32r    a11, .LC96
        movi.n  a12, 1
        call8   attachInterrupt
        l8ui    a10, a2, 20
        l32r    a11, .LC97
        movi.n  a12, 1
        call8   attachInterrupt
        l16ui   a11, a2, 24
        movi.n  a12, 1
        movi.n  a10, 0
        call8   timerBegin
        l32r    a11, .LC99
        l32r    a2, .LC98
        movi.n  a12, 1
        s32i.n  a10, a2, 0
        call8   timerAttachInterrupt
        l32r    a3, .LC100
        l8ui    a3, a3, 0
        bnez.n  a3, .L87
#
        movi.n  a6, 0
        mov.n   a5, a6
        j       .L88
.L87:
        l32i.n  a10, a2, 0
        call8   timerGetDivider
        l32r    a3, .LC80       # Get TimeSwitch pointer
        l32r    a2, .LC101
        quos    a10, a2, a10
        l32i.n  a2, a3, 0
        or      a10, a10, a2
        l32r    a2, .LC102
        s32i.n  a10, a3, 0
        and     a10, a10, a2
        bne     a10, a2, .L93
#
        retw.n
.L92:
        mov.n   a6, a4
        mov.n   a5, a11
.L88:
        l32i.n  a10, a2, 0
        movi.n  a7, 1
        call8   timerRead
        l32i.n  a10, a2, 0
        call8   timerRead
        mov.n   a4, a10
        movi    a10, 0x64
        s32i.n  a11, sp, 16
        call8   delay
        l32i.n  a10, a2, 0
        call8   timerRead
        l32i.n  a10, a2, 0
        call8   timerRead
        sub     a4, a10, a4
        l32i.n  a8, sp, 16
        bltu    a10, a4, .L91
#
        movi.n  a7, 0
.L91:
        sub     a11, a11, a8
        sub     a11, a11, a7
        bne     a4, a6, .L92
#
        bne     a11, a5, .L92
#
        addi.n  a3, a3, 1
        extui   a3, a3, 0, 8
        bltui   a3, 3, .L92
#
        j       .L87
.L93:
        j       .L93
        .size   _ZN8McuClass4initEiiiiPj, .-_ZN8McuClass4initEiiiiPj
#
#-------------------------------------------------------------------------------
#
        .section        .rodata.str1.1
.LC109:
        .string "Deep Sleep until Next TxPacket:%d ms\r\n"
        .section        .text._ZN8McuClass5sleepEhh,"ax",@progbits
        .literal_position
        .literal .LC103, TimerListHead
        .literal .LC104, TxNextPacketTimer
        .literal .LC105, IsLoRaMacNetworkJoined
        .literal .LC106, toDeepSleep
        .literal .LC107, nextAlarm
        .literal .LC110, .LC109
        .align  4
        .global _ZN8McuClass5sleepEhh
        .type   _ZN8McuClass5sleepEhh, @function
_ZN8McuClass5sleepEhh:
        entry   sp, 32
        extui   a3, a3, 0, 8
        extui   a4, a4, 0, 8
        beqz.n  a3, .L96
.L98:
        l32r    a2, .LC107
        j       .L97
.L96:
        l32r    a2, .LC103
        l32r    a3, .LC104
        l32i.n  a2, a2, 0
        bne     a2, a3, .L98
        l32i.n  a5, a2, 16
        bnez.n  a5, .L98
        l32r    a2, .LC105
        l8ui    a2, a2, 0
        beqz.n  a2, .L98
        l32r    a3, .LC106
        l8ui    a2, a3, 0
        bgeui   a2, 5, .L99
        addi.n  a2, a2, 1
        s8i     a2, a3, 0
        retw.n
.L99:
        call8   TimerGetTimerValue
        l32r    a3, .LC107
        movi.n  a9, 1
        l32i.n  a12, a3, 0
        l32i.n  a8, a3, 4
        sub     a3, a12, a10
        bltu    a12, a3, .L101
        mov.n   a9, a5
.L101:
        sub     a8, a8, a11
        sub     a2, a8, a9
        movi    a8, -0x3e9
        add.n   a8, a3, a8
        movi.n  a10, 1
        bltu    a8, a3, .L102
        movi.n  a10, 0
.L102:
        addi.n  a9, a2, -1
        add.n   a9, a10, a9
        bnez.n  a9, .L98
        movi    a5, -0x3eb
        bltu    a5, a8, .L98
        beqz.n  a4, .L104
        l32r    a10, .LC110
        mov.n   a11, a3
        call8   lora_printf
        movi.n  a10, 8
        call8   delay
.L104:
        movi    a10, 0x3e8
        mull    a2, a10, a2
        muluh   a11, a10, a3
        mull    a10, a10, a3
        add.n   a11, a2, a11
        call8   esp_sleep_enable_timer_wakeup
        movi.n  a11, 1
        movi.n  a10, 4
        call8   pinMode
        movi.n  a11, 1
        movi.n  a10, 5
        call8   pinMode
        movi.n  a11, 1
        movi.n  a10, 0xe
        call8   pinMode
        movi.n  a11, 1
        movi.n  a10, 0xf
        call8   pinMode
        movi.n  a11, 1
        movi.n  a10, 0x10
        call8   pinMode
        movi.n  a11, 1
        movi.n  a10, 0x11
        call8   pinMode
        movi.n  a11, 1
        movi.n  a10, 0x12
        call8   pinMode
        movi.n  a11, 1
        movi.n  a10, 0x13
        call8   pinMode
        movi.n  a11, 1
        movi.n  a10, 0x1a
        call8   pinMode
        movi.n  a11, 1
        movi.n  a10, 0x1b
        call8   pinMode
        call8   esp_deep_sleep_start
.L97:
        call8   TimerGetTimerValue
        l32i.n  a8, a2, 4
        mov.n   a3, a2
        bltu    a11, a8, .L105
        bne     a8, a11, .L109
        l32i.n  a4, a2, 0
        bltu    a10, a4, .L105
.L109:
        call8   TimerGetTimerValue
        l32i.n  a2, a3, 4
        bltu    a11, a2, .L95
        bne     a2, a11, .L107
        l32i.n  a2, a3, 0
        bltu    a10, a2, .L95
        j       .L107
.L105:
        call8   TimerGetTimerValue
        addi    a8, a10, 100
        movi.n  a9, 1
        bltu    a8, a10, .L110
        movi.n  a9, 0
.L110:
        add.n   a11, a9, a11
        l32i.n  a9, a2, 4
        bltu    a9, a11, .L97
        bne     a9, a11, .L109
        l32i.n  a4, a2, 0
        bltu    a4, a8, .L97
        j       .L109
.L107:
        call8   TimerIrqHandler
.L95:
        retw.n
        .size   _ZN8McuClass5sleepEhh, .-_ZN8McuClass5sleepEhh
#
#-------------------------------------------------------------------------------
#
        .global Mcu
        .section        .bss.Mcu,"aw",@nobits
        .align  4
        .type   Mcu, @object
        .size   Mcu, 28
Mcu:
        .zero   28
        .global toDeepSleep
        .section        .bss.toDeepSleep,"aw",@nobits
        .type   toDeepSleep, @object
        .size   toDeepSleep, 1
toDeepSleep:
        .zero   1
        .global Irq1Fired
        .section        .rtc.data,"aw",@progbits
        .type   Irq1Fired, @object
        .size   Irq1Fired, 1
Irq1Fired:
        .zero   1
        .global Irq0Fired
        .type   Irq0Fired, @object
        .size   Irq0Fired, 1
Irq0Fired:
        .zero   1
        .global mcuStarted
        .type   mcuStarted, @object
        .size   mcuStarted, 1
mcuStarted:
        .zero   1
        .global Codeid
        .align  4
        .type   Codeid, @object
        .size   Codeid, 16
Codeid:
        .zero   16
        .global factory_test
        .section        .bss.factory_test,"aw",@nobits
        .type   factory_test, @object
        .size   factory_test, 1
factory_test:
        .zero   1
        .global timer
        .section        .bss.timer,"aw",@nobits
        .align  4
        .type   timer, @object
        .size   timer, 4
timer:
        .zero   4
        .section        .bss._ZL11INADDR_NONE,"aw",@nobits
        .align  4
        .type   _ZL11INADDR_NONE, @object
        .size   _ZL11INADDR_NONE, 8
_ZL11INADDR_NONE:
        .zero   8
        .ident  "GCC: (crosstool-NG crosstool-ng-1.22.0-80-g6c4433a5) 5.2.0"
