package com.masdmtr.skillsmonster;

import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


@SpringBootApplication
public class SkillsMonsterApplication {
    private static final Logger log = LoggerFactory.getLogger(SkillsMonsterApplication.class);

    public static void main(String[] args) {
        SpringApplication.run(SkillsMonsterApplication.class, args);
    }

    @Bean
    public RestTemplate restTemplate(RestTemplateBuilder builder) {
        return builder.build();
    }

    @Bean
    public CommandLineRunner run(RestTemplate restTemplate) throws Exception {
        return args -> {
            //Quote quote = restTemplate.getForObject("http://gturnquist-quoters.cfapps.io/api/random", Quote.class);

            //Object obj = restTemplate.getForObject("https://api.hh.ru/industries", Object.class);
            //String response = restTemplate.getForObject("https://api.hh.ru/industries", String.class);

            log.info("log_string");
        };
    }
}
