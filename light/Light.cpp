/*
 * Copyright (C) 2017 The LineageOS Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#define LOG_TAG "LightService"

#include <log/log.h>

#include "Light.h"

#include <fstream>
#include <string>  // for std::string
#include <cstdio>  // for std::snprintf
#include <cstdint> // for std::uint32_t

constexpr const char* RED_LED_FILE = "/sys/class/leds/red/brightness";
constexpr const char* GREEN_LED_FILE = "/sys/class/leds/green/brightness";
constexpr const char* RED_BLINK_FILE = "/sys/class/leds/red/blink";
constexpr const char* GREEN_BLINK_FILE = "/sys/class/leds/green/blink";
constexpr int LED_LIGHT_OFF = 0;

namespace android {
namespace hardware {
namespace light {
namespace V2_0 {
namespace implementation {

#define LEDS            "/sys/class/backlight/"

#define LCD_LED         LEDS "psb-bl/"
#define RED_LED         LEDS "red/"
#define GREEN_LED       LEDS "green/"
#define BLUE_LED        LEDS "blue/"
#define RGB_LED         LEDS "rgb/"

#define BRIGHTNESS      "brightness"
#define DUTY_PCTS       "duty_pcts"
#define START_IDX       "start_idx"
#define PAUSE_LO        "pause_lo"
#define PAUSE_HI        "pause_hi"
#define RAMP_STEP_MS    "ramp_step_ms"
#define RGB_BLINK       "rgb_blink"

/*
 * 8 duty percent steps.
 */
#define RAMP_STEPS 8
/*
 * Each step will stay on for 50ms by default.
 */
#define RAMP_STEP_DURATION 50

// Function to write a string to a file at the specified path
static int write_str(const char* path, const char* str) {
    int fd;
    static int already_warned = 0;

    fd = open(path, O_RDWR);
    if (fd >= 0) {
        ssize_t amt = write(fd, str, strlen(str));
        close(fd);
        return amt == -1 ? -errno : 0;
    } else {
        if (already_warned == 0) {
            ALOGE("write_str failed to open %s", path); // Updated to use ALOGE
            already_warned = 1;
        }
        return -errno;
    }
}

// Function to write an integer value to a file at the specified path
static int write_int(const char* path, int value) {
    char buffer[20];
    std::snprintf(buffer, sizeof(buffer), "%d\n", value);
    return write_str(path, buffer);
}

// Function to write a blink configuration to a file at the specified path
static int write_blink(const char* path, int value, int on_ms, int off_ms) {
    char buffer[100];
    std::snprintf(buffer, sizeof(buffer), "%d %d %d\n", value, on_ms, off_ms);
    return write_str(path, buffer);
}

// Function to set the light configuration
static int set_light_locked(const LightState& state) {
    int blink;
    int red = 0;
    int green = 0;
    int blue = 0;
    std::uint32_t colorRGB = state.color;

    switch (state.flashMode) {
        case Flash::TIMED:
        case Flash::HARDWARE:
            blink = 1;
            break;
        case Flash::NONE:
        default:
            blink = 0;
            break;
    }

    red = (colorRGB >> 16) & 0xFF;
    green = (colorRGB >> 8) & 0xFF;
    blue = colorRGB & 0xFF;

    if (blue) {
        green = red = blue;
    }

    // Log the light configuration (updated to use ALOGE)
    ALOGE("set_light_locked colorRGB=%08X, red=%d, green=%d, blink=%d", 
          colorRGB, red, green, blink);

    if (blink) {
        write_int(RED_LED_FILE, LED_LIGHT_OFF);
        write_int(GREEN_LED_FILE, LED_LIGHT_OFF);
        write_blink(RED_BLINK_FILE, (red ? 1 : 0), state.flashOnMs, state.flashOffMs);
        write_blink(GREEN_BLINK_FILE, (green ? 1 : 0), state.flashOnMs, state.flashOffMs);
    } else {
        write_int(RED_BLINK_FILE, blink);
        write_int(GREEN_BLINK_FILE, blink);
        write_int(RED_LED_FILE, LED_LIGHT_OFF);
        write_int(GREEN_LED_FILE, LED_LIGHT_OFF);
        write_int(RED_LED_FILE, red);
        write_int(GREEN_LED_FILE, green);
    }

    return 0; // Return success
}


/*
 * Write value to path and close file.
 */
static void set(std::string path, std::string value) {
    std::ofstream file(path);

    if (!file.is_open()) {
        ALOGE("failed to write %s to %s", value.c_str(), path.c_str());
        return;
    }

    file << value;
}

static void set(std::string path, int value) {
    set(path, std::to_string(value));
}

static void handleBacklight(const LightState& state) {
    uint32_t brightness = state.color & 0xFF;
    set(LCD_LED BRIGHTNESS, brightness);
}

 static void handleNotification(const LightState& state) {
    set_light_locked(state);
 }
// static void handleNotification(const LightState& state) {
//     uint32_t redBrightness, greenBrightness, blueBrightness, brightness;

//     // /*
//     //  * Extract brightness from AARRGGBB.
//     //  */
//     // redBrightness = (state.color >> 16) & 0xFF;
//     // greenBrightness = (state.color >> 8) & 0xFF;
//     // blueBrightness = state.color & 0xFF;

//     // brightness = (state.color >> 24) & 0xFF;

//     // /*
//     //  * Scale RGB brightness if the Alpha brightness is not 0xFF.
//     //  */
//     // if (brightness != 0xFF) {
//     //     redBrightness = (redBrightness * brightness) / 0xFF;
//     //     greenBrightness = (greenBrightness * brightness) / 0xFF;
//     //     blueBrightness = (blueBrightness * brightness) / 0xFF;
//     // }

//     // /* Disable blinking. */
//     // set(RGB_LED RGB_BLINK, 0);

//     // if (state.flashMode == Flash::TIMED) {
//     //     /*
//     //      * If the flashOnMs duration is not long enough to fit ramping up
//     //      * and down at the default step duration, step duration is modified
//     //      * to fit.
//     //      */
//     //     int32_t stepDuration = RAMP_STEP_DURATION;
//     //     int32_t pauseHi = state.flashOnMs - (stepDuration * RAMP_STEPS * 2);
//     //     int32_t pauseLo = state.flashOffMs;

//     //     if (pauseHi < 0) {
//     //         stepDuration = state.flashOnMs / (RAMP_STEPS * 2);
//     //         pauseHi = 0;
//     //     }

//     //     /* Red */
//     //     set(RED_LED START_IDX, 0 * RAMP_STEPS);
//     //     set(RED_LED DUTY_PCTS, getScaledRamp(redBrightness));
//     //     set(RED_LED PAUSE_LO, pauseLo);
//     //     set(RED_LED PAUSE_HI, pauseHi);
//     //     set(RED_LED RAMP_STEP_MS, stepDuration);

//     //     /* Green */
//     //     set(GREEN_LED START_IDX, 1 * RAMP_STEPS);
//     //     set(GREEN_LED DUTY_PCTS, getScaledRamp(greenBrightness));
//     //     set(GREEN_LED PAUSE_LO, pauseLo);
//     //     set(GREEN_LED PAUSE_HI, pauseHi);
//     //     set(GREEN_LED RAMP_STEP_MS, stepDuration);

//     //     /* Blue */
//     //     set(BLUE_LED START_IDX, 2 * RAMP_STEPS);
//     //     set(BLUE_LED DUTY_PCTS, getScaledRamp(blueBrightness));
//     //     set(BLUE_LED PAUSE_LO, pauseLo);
//     //     set(BLUE_LED PAUSE_HI, pauseHi);
//     //     set(BLUE_LED RAMP_STEP_MS, stepDuration);

//     //     /* Enable blinking. */
//     //     set(RGB_LED RGB_BLINK, 1);
//     // } else {
//     //     set(RED_LED BRIGHTNESS, redBrightness);
//     //     set(GREEN_LED BRIGHTNESS, greenBrightness);
//     //     set(BLUE_LED BRIGHTNESS, blueBrightness);
//     // }
// }

static std::map<Type, std::function<void(const LightState&)>> lights = {
    {Type::BACKLIGHT, handleBacklight},
    {Type::BATTERY, handleNotification},
    {Type::NOTIFICATIONS, handleNotification},
    {Type::ATTENTION, handleNotification},
};

Light::Light() {}

Return<Status> Light::setLight(Type type, const LightState& state) {
    auto it = lights.find(type);

    if (it == lights.end()) {
        return Status::LIGHT_NOT_SUPPORTED;
    }

    /*
     * Lock global mutex until light state is updated.
     */
    std::lock_guard<std::mutex> lock(globalLock);

    it->second(state);

    return Status::SUCCESS;
}

Return<void> Light::getSupportedTypes(getSupportedTypes_cb _hidl_cb) {
    std::vector<Type> types;

    for (auto const& light : lights) types.push_back(light.first);

    _hidl_cb(types);

    return Void();
}

}  // namespace implementation
}  // namespace V2_0
}  // namespace light
}  // namespace hardware
}  // namespace android
