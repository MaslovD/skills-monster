package com.masdmtr.skillsmonster.receiver;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * Created by dmaslov on 7/31/17.
 */

public abstract class ReceiverImpl implements Receiver {
    @Autowired
    Receiver receiver;
}
