package br.com.copacabana.cb.entities;

import java.sql.Timestamp;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;

import com.google.appengine.api.datastore.Key;
import com.google.gson.annotations.Expose;
@Entity
@NamedQueries({@NamedQuery(name="getRecommendation", query = "SELECT r FROM Recommendation r"),@NamedQuery(name="getRecommendationOrdered", query = "SELECT r FROM Recommendation r ORDER BY r.id"),
@NamedQuery(name="getRecommendationByText", query = "SELECT r FROM Recommendation r WHERE r.text = :text"),
@NamedQuery(name="getRecommendationByGrade", query = "SELECT r FROM Recommendation r WHERE r.grade = :grade"),
@NamedQuery(name="getRecommendationByPerson", query = "SELECT r FROM Recommendation r WHERE r.person = :person"),
@NamedQuery(name="getRecommendationByDate", query = "SELECT r FROM Recommendation r WHERE r.date = :date")})
public class Recommendation {

	public Key getId() {
		return id;
	}
	public void setId(Key id) {
		this.id = id;
	}
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Expose
	private Key id;
	private String text;
	private int grade;
	private Person person;
	private Timestamp date;
	public Timestamp getDate() {
		return date;
	}
	public int getGrade() {
		return grade;
	}
	public Person getPerson() {
		return person;
	}
	public String getText() {
		return text;
	}
	public void setDate(Timestamp date) {
		this.date = date;
	}
	public void setGrade(int grade) {
		this.grade = grade;
	}
	public void setPerson(Person person) {
		this.person = person;
	}
	public void setText(String text) {
		this.text = text;
	}
	
}
