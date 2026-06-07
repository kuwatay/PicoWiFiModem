#pragma once

#include <string.h>
#include "pico/stdlib.h"
#include "hardware/flash.h"
#include "hardware/sync.h"

#define FLASH_SETTINGS_OFFSET  (2 * 1024 * 1024 - FLASH_SECTOR_SIZE)
// #define FLASH_SETTINGS_OFFSET (PICO_FLASH_SIZE_BYTES - FLASH_SECTOR_SIZE)
#define FLASH_SETTINGS_ADDR   (XIP_BASE + FLASH_SETTINGS_OFFSET)

static inline void initEEPROM(void)
{
    // nothing
}

static inline bool readSettings(SETTINGS_T *settings)
{
    memcpy(settings,
	   (const uint8_t *)FLASH_SETTINGS_ADDR,
	    sizeof(SETTINGS_T));

    return settings->magicNumber == MAGIC_NUMBER;
}

static inline bool writeSettings(SETTINGS_T *settings)
{
    uint8_t buffer[FLASH_SECTOR_SIZE];

    memset(buffer, 0xFF, sizeof(buffer));

    memcpy(buffer,
           settings,
           sizeof(SETTINGS_T));

    uint32_t ints = save_and_disable_interrupts();

    flash_range_erase(FLASH_SETTINGS_OFFSET,
                      FLASH_SECTOR_SIZE);

    flash_range_program(FLASH_SETTINGS_OFFSET,
                        buffer,
                        FLASH_SECTOR_SIZE);

    restore_interrupts(ints);

    // verify 
    SETTINGS_T verify;
    memcpy(&verify, (const void *)FLASH_SETTINGS_ADDR, sizeof(SETTINGS_T));

    return verify.magicNumber == MAGIC_NUMBER &&
           strcmp(verify.ssid, settings->ssid) == 0 &&
           strcmp(verify.wifiPassword, settings->wifiPassword) == 0;

}

