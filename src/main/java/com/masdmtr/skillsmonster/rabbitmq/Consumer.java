package com.masdmtr.skillsmonster.rabbitmq;

import com.masdmtr.skillsmonster.dto.ProcessingQueueItem;
import com.masdmtr.skillsmonster.receiver.HeadHunterReceiver;
import com.masdmtr.skillsmonster.receiver.Receiver;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * Created by dmaslov on 02/01/2018.
 */

@Service
public class Consumer {
    private static final Logger logger = LoggerFactory.getLogger(Consumer.class);
    private Receiver receiver;

    @Autowired
    public Consumer(Receiver receiver) {
        this.receiver = receiver;
    }

    @RabbitListener(queues = "${spring.rabbitmq.skillsmonster.queue.searchResults}")
    public void receiveQueueItemLevel1(final ProcessingQueueItem processingQueueItem) throws InterruptedException {
        receiver.loadVacancyDetailsMq(processingQueueItem);
    }
}