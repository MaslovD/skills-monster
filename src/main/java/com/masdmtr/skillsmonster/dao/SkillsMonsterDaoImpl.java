package com.masdmtr.skillsmonster.dao;

import com.masdmtr.skillsmonster.entity.Country;
import com.masdmtr.skillsmonster.entity.SearchResult;
import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Created by dmaslov on 09/07/17.
 */

@Repository
@Transactional
@Component
public class SkillsMonsterDaoImpl implements SkillsMonsterDao {

    @Autowired
    private SessionFactory sessionFactory;

    public List<Country> getCountryList() {

        Criteria criteria = sessionFactory.openSession().createCriteria(Country.class);

        List<Country> tmpList = criteria.list();

        return criteria.list();
    }

    @Override
    public void addCountry(Country country, SearchResult searchResult) {
        System.out.println();
        //sessionFactory.openSession().persist(country);

        Session session = sessionFactory.openSession();

        Transaction tx1 = session.beginTransaction();

        //session.save(country);
        session.save(country);
        session.save(searchResult);

        tx1.commit();

        session.flush();
        session.close();
    }
}