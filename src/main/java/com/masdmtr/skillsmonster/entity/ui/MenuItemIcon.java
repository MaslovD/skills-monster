package com.masdmtr.skillsmonster.entity.ui;

import com.fasterxml.jackson.annotation.JsonProperty;

import javax.persistence.*;

/**
 * Created by dmaslov on 8/22/17.
 */
@Entity
@Table(name = "ui_menu_item_icon", schema = "public", catalog = "skillsmonster")
public class MenuItemIcon {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    @Basic
    @JsonProperty("class")
    @Column(name = "class", nullable = true, length = 100)
    private String icon_clazz;
    @Basic
    @Column(name = "color", nullable = true, length = 100)
    private String color;
    @Basic
    @Column(name = "bg", nullable = true, length = 100)
    private String bg;

    public String getIcon_clazz() {
        return icon_clazz;
    }

    public void setIcon_name(String icon_class) {
        this.icon_clazz = icon_class;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public String getBg() {
        return bg;
    }

    public void setBg(String bg) {
        this.bg = bg;
    }
}
