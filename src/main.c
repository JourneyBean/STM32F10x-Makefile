#include "init.h"
#include "led.h"
#include "stm32f10x.h"

int main( void ) {
    
    InitGPIOC();
    InitGPIOB();
    InitGPIOA();
    
    while(1) {
        Light();
        GPIO_SetBits(GPIOA, GPIO_Pin_All);
        GPIO_SetBits(GPIOB, GPIO_Pin_All);
        delay_ms(1500);
        Mute();
        GPIO_ResetBits(GPIOA, GPIO_Pin_All);
        GPIO_ResetBits(GPIOB, GPIO_Pin_All);
        delay_ms(1500);
    }
}
