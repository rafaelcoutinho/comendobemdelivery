package br.com.copacabana.cb.entities;

import javax.jdo.annotations.ForeignKey;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

@Entity
public class OrderedSideDish {
	@Id
	@Column(name = "id")
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	@ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "sidedish_id", nullable = false)
	@ForeignKey
	private SideDish sideDish;

	private Double price;
	@ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "orderedplate_id", nullable = false)
	@ForeignKey
	private OrderedPlate plateOrdered;

	public OrderedSideDish() {

	}

	public OrderedSideDish(OrderedPlate plateOrdered, SideDish sideDish2) {
		this.plateOrdered = plateOrdered;
		price = sideDish2.getPrice();
		sideDish = sideDish2;

	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public SideDish getSideDish() {
		return sideDish;
	}

	public void setSideDish(SideDish sideDish) {
		this.sideDish = sideDish;
	}

	public Double getPrice() {
		return price;
	}

	public void setPrice(Double price) {
		this.price = price;
	}

	public OrderedPlate getPlateOrdered() {
		return plateOrdered;
	}

	public void setPlateOrdered(OrderedPlate plateOrdered) {
		this.plateOrdered = plateOrdered;
	}

}
