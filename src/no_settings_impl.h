#pragma once

static inline void initEEPROM(void){
}

static inline bool readSettings(SETTINGS_T *settings){
    return false;   // 必ず factoryDefaults() させる
}

static inline bool writeSettings(SETTINGS_T *settings){
    return true;    // 何もしない
}
