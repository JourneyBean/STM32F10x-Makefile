#include "init.h"
#include "stm32f10x.h"
#include "pindef.h"

void InitGPIOA( void ) {
    
    GPIO_InitTypeDef GPIO_InitStructure;
	
	SystemInit();
	
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA, ENABLE);
	
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_All;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
	
	GPIO_Init(GPIOA, &GPIO_InitStructure);
}
void InitGPIOB( void ) {
    
    GPIO_InitTypeDef GPIO_InitStructure;
	
	SystemInit();
	
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOB, ENABLE);
	
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_All;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
	
	GPIO_Init(GPIOB, &GPIO_InitStructure);
}
void InitGPIOC( void ) {
    
    GPIO_InitTypeDef GPIO_InitStructure;
	
	SystemInit();
	
	RCC_APB2PeriphClockCmd(LED_GPIO_CLK, ENABLE);
	
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_InitStructure.GPIO_Pin = LED_GPIO_PIN;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
	
	GPIO_Init(LED_GPIO_GRP, &GPIO_InitStructure);
}

void delay_ms(u32 i) {
	u32 temp;
	SysTick->LOAD = 9000*i;
	SysTick->CTRL = 0x01;
	SysTick->VAL = 0;
	do {
		temp = SysTick->CTRL;
	}
	while((temp&0x01)&&(!(temp&(1<<16))));
	SysTick->CTRL = 0;
	SysTick->VAL = 0;
}
