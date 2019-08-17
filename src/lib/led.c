#include "led.h"
#include "stm32f10x.h"
#include "pindef.h"

void Light( void ) {
    
    GPIO_SetBits(LED_GPIO_GRP, LED_GPIO_PIN);
}

void Mute( void ) {
    
    GPIO_ResetBits(LED_GPIO_GRP, LED_GPIO_PIN);
}
