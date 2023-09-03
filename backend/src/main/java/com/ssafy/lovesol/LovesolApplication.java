package com.ssafy.lovesol;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@EnableScheduling
@SpringBootApplication
public class LovesolApplication {

	public static void main(String[] args) {
		SpringApplication.run(LovesolApplication.class, args);
	}

}
