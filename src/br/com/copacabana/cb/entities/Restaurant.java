package br.com.copacabana.cb.entities;

import java.io.Serializable;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashSet;
import java.util.Locale;
import java.util.Set;
import java.util.TimeZone;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Basic;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.DiscriminatorColumn;
import javax.persistence.DiscriminatorValue;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.PostLoad;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Transient;

import br.com.copacabana.cb.entities.WorkingHours.DayOfWeek;
import br.copacabana.util.TimeController;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.gson.annotations.Expose;

@Entity
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(name = "RESTAURANT_TYPE")
@DiscriminatorValue("normal")
@NamedQueries({ @NamedQuery(name = "getRestaurant", query = "SELECT r FROM Restaurant r"), 
	@NamedQuery(name = "getRestaurantByName", query = "SELECT r FROM Restaurant r WHERE r.name = :name"), 
	@NamedQuery(name = "getRestaurantByAddress", query = "SELECT r FROM Restaurant r WHERE r.address = :address"),
	@NamedQuery(name = "getRestaurantOrdered", query = "SELECT r FROM Restaurant r ORDER BY r.id"),
	@NamedQuery(name = "getRestaurantByName", query = "SELECT r FROM Restaurant r WHERE r.name = :name"),
	@NamedQuery(name = "searchRestaurant", query = "SELECT r FROM Restaurant r WHERE r.name like :name"), 
	@NamedQuery(name = "restaurantByAddress", query = "SELECT r FROM Restaurant r WHERE r.address = :address"), 
	@NamedQuery(name = "restaurantByUserBean", query = "SELECT r FROM Restaurant r WHERE r.user = :login"), 
	@NamedQuery(name = "restaurantByUrlName", query = "SELECT r FROM Restaurant r WHERE r.uniqueUrlName = :uniqueUrlName"),
	@NamedQuery(name = "restaurantKeys", query = "SELECT r.id FROM Restaurant r"),

})
public class Restaurant implements Serializable {
	public static enum SiteStatus {
		NEW_RESTAURANT, BLOCKED, ACTIVE, MUSTACCEPTTERMS, SOON, TEMPUNAVAILABLE
	};

	public Restaurant(Key address, String email, String formalName, String personInChargeName, String name) {
		super();
		this.address = address;
		this.user = new UserBean(email);
		this.contact = new ContactInfo(email);
		this.formalName = formalName;
		this.personInChargeName = personInChargeName;
		this.name = name;

	}

	public Restaurant() {
		super();
	}

	/**
	 * 
	 */
	private static final long serialVersionUID = 4966424616438432081L;

	@Expose
	private Key address;

	@Enumerated(EnumType.STRING)
	@Expose
	private SiteStatus siteStatus = SiteStatus.NEW_RESTAURANT;

	@Temporal(TemporalType.DATE)
	private Date lastAcceptedTermsDate = new Date();

	@OneToOne(optional = false, cascade = CascadeType.ALL)
	@Expose
	private ContactInfo contact = new ContactInfo();
	@Expose
	private Boolean onlyForRetrieval = false;
	@Expose
	private String description;

	@Expose
	private String imgKeyString;

	@Expose
	private String formalName;

	@Expose
	private String currentDelay = "30";

	@Expose
	private String formalDocumentId;

	@Expose
	private String personInChargeName;

	// @Expose
	// @OneToMany(cascade = CascadeType.PERSIST, fetch = FetchType.EAGER)
	// private List<Key> foodCategories2 = new ArrayList<Key>();

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Expose
	private Key id;
	@Expose
	private String imageAlt;
	@Expose
	private String imageUrl;
	@Expose
	@Transient
	private boolean isOpen = false;
	@Expose
	@Transient
	private boolean opensToday = true;
	@Expose
	@Basic(fetch = FetchType.EAGER)
	private Set<String> acceptablePayments = new HashSet<String>();

	@Expose
	@Transient
	private String closingString = "-1:-1";
	@Expose
	@Transient
	private String openingString = "-1:-1";
	@Expose
	@Transient
	private Boolean hasSecondTurn = Boolean.FALSE;
	@Expose
	@Transient
	private String secTurnClosingString = "-1:-1";
	@Expose
	@Transient
	private String secTurnOpeningString = "-1:-1";

	@Expose
	private String name;

	@Expose
	private String uniqueUrlName;

	@Expose
	@Enumerated(EnumType.STRING)
	private FractionPriceType fractionPriceType = FractionPriceType.HALFHALF;

	@OneToMany(fetch = FetchType.EAGER, cascade = { CascadeType.ALL }, mappedBy = "restaurant")
	@Column(name = "plates", insertable = true, updatable = true)
	private Set<Plate> plates = new HashSet<Plate>();

	@OneToMany(fetch = FetchType.EAGER, cascade = { CascadeType.ALL }, mappedBy = "restaurant")
	@Column(name = "deliveryRange", insertable = true, updatable = true)
	private Set<DeliveryRange> deliveryRanges = new HashSet<DeliveryRange>();

	@Embedded
	@AttributeOverrides({ @AttributeOverride(name = "closed", column = @Column(name = "monClosed")), @AttributeOverride(name = "secondTurn", column = @Column(name = "monSecondTurn")), @AttributeOverride(name = "startingHour", column = @Column(name = "monStartingHour")), @AttributeOverride(name = "startingMinute", column = @Column(name = "monStartingMinute")), @AttributeOverride(name = "closingMinute", column = @Column(name = "monClosingMinute")), @AttributeOverride(name = "closingHour", column = @Column(name = "monClosingHour")), @AttributeOverride(name = "description", column = @Column(name = "monDescription")), @AttributeOverride(name = "timezone", column = @Column(name = "monTimezone")), @AttributeOverride(name = "day", column = @Column(name = "mon")) })
	private WorkingHours mon = new WorkingHours(DayOfWeek.MONDAY);
	@Embedded
	@AttributeOverrides({ @AttributeOverride(name = "closed", column = @Column(name = "tueClosed")), @AttributeOverride(name = "secondTurn", column = @Column(name = "tueSecondTurn")), @AttributeOverride(name = "startingHour", column = @Column(name = "tueStartingHour")), @AttributeOverride(name = "startingMinute", column = @Column(name = "tueStartingMinute")), @AttributeOverride(name = "closingMinute", column = @Column(name = "tueClosingMinute")), @AttributeOverride(name = "closingHour", column = @Column(name = "tueClosingHour")), @AttributeOverride(name = "description", column = @Column(name = "tueDescription")), @AttributeOverride(name = "timezone", column = @Column(name = "tueTimezone")), @AttributeOverride(name = "day", column = @Column(name = "tue")) })
	private WorkingHours tue = new WorkingHours(DayOfWeek.TUESDAY);
	@Embedded
	@AttributeOverrides({ @AttributeOverride(name = "closed", column = @Column(name = "wedClosed")), @AttributeOverride(name = "secondTurn", column = @Column(name = "wedSecondTurn")), @AttributeOverride(name = "startingHour", column = @Column(name = "wedStartingHour")), @AttributeOverride(name = "startingMinute", column = @Column(name = "wedStartingMinute")), @AttributeOverride(name = "closingMinute", column = @Column(name = "wedClosingMinute")), @AttributeOverride(name = "closingHour", column = @Column(name = "wedClosingHour")), @AttributeOverride(name = "description", column = @Column(name = "wedDescription")), @AttributeOverride(name = "timezone", column = @Column(name = "wedTimezone")), @AttributeOverride(name = "day", column = @Column(name = "wed")) })
	private WorkingHours wed = new WorkingHours(DayOfWeek.WEDNESDAY);
	@Embedded
	@AttributeOverrides({ @AttributeOverride(name = "closed", column = @Column(name = "thuClosed")), @AttributeOverride(name = "secondTurn", column = @Column(name = "thuSecondTurn")), @AttributeOverride(name = "startingHour", column = @Column(name = "thuStartingHour")), @AttributeOverride(name = "startingMinute", column = @Column(name = "thuStartingMinute")), @AttributeOverride(name = "closingMinute", column = @Column(name = "thuClosingMinute")), @AttributeOverride(name = "closingHour", column = @Column(name = "thuClosingHour")), @AttributeOverride(name = "description", column = @Column(name = "thuDescription")), @AttributeOverride(name = "timezone", column = @Column(name = "thuTimezone")), @AttributeOverride(name = "day", column = @Column(name = "thu")) })
	private WorkingHours thu = new WorkingHours(DayOfWeek.THURSDAY);
	@Embedded
	@AttributeOverrides({ @AttributeOverride(name = "closed", column = @Column(name = "friClosed")), @AttributeOverride(name = "secondTurn", column = @Column(name = "friSecondTurn")), @AttributeOverride(name = "startingHour", column = @Column(name = "friStartingHour")), @AttributeOverride(name = "startingMinute", column = @Column(name = "friStartingMinute")), @AttributeOverride(name = "closingMinute", column = @Column(name = "friClosingMinute")), @AttributeOverride(name = "closingHour", column = @Column(name = "friClosingHour")), @AttributeOverride(name = "description", column = @Column(name = "friDescription")), @AttributeOverride(name = "timezone", column = @Column(name = "friTimezone")), @AttributeOverride(name = "day", column = @Column(name = "fri")) })
	private WorkingHours fri = new WorkingHours(DayOfWeek.FRIDAY);
	@Embedded
	@AttributeOverrides({ @AttributeOverride(name = "closed", column = @Column(name = "satClosed")), @AttributeOverride(name = "secondTurn", column = @Column(name = "satSecondTurn")), @AttributeOverride(name = "startingHour", column = @Column(name = "satStartingHour")), @AttributeOverride(name = "startingMinute", column = @Column(name = "satStartingMinute")), @AttributeOverride(name = "closingMinute", column = @Column(name = "satClosingMinute")), @AttributeOverride(name = "closingHour", column = @Column(name = "satClosingHour")), @AttributeOverride(name = "description", column = @Column(name = "satDescription")), @AttributeOverride(name = "timezone", column = @Column(name = "satTimezone")), @AttributeOverride(name = "day", column = @Column(name = "sat")) })
	private WorkingHours sat = new WorkingHours(DayOfWeek.SATURDAY);

	@Embedded
	@AttributeOverrides({ @AttributeOverride(name = "closed", column = @Column(name = "sunClosed")), @AttributeOverride(name = "secondTurn", column = @Column(name = "sunSecondTurn")), @AttributeOverride(name = "startingHour", column = @Column(name = "sunStartingHour")), @AttributeOverride(name = "startingMinute", column = @Column(name = "sunStartingMinute")), @AttributeOverride(name = "closingMinute", column = @Column(name = "sunClosingMinute")), @AttributeOverride(name = "closingHour", column = @Column(name = "sunClosingHour")), @AttributeOverride(name = "description", column = @Column(name = "sunDescription")), @AttributeOverride(name = "timezone", column = @Column(name = "sunTimezone")), @AttributeOverride(name = "day", column = @Column(name = "sun")) })
	private WorkingHours sun = new WorkingHours(DayOfWeek.SUNDAY);

	@Embedded
	@AttributeOverrides({ @AttributeOverride(name = "closed", column = @Column(name = "holClosed")), @AttributeOverride(name = "secondTurn", column = @Column(name = "holiSecondTurn")), @AttributeOverride(name = "startingHour", column = @Column(name = "holStartingHour")), @AttributeOverride(name = "startingMinute", column = @Column(name = "holStartingMinute")), @AttributeOverride(name = "closingMinute", column = @Column(name = "holClosingMinute")), @AttributeOverride(name = "closingHour", column = @Column(name = "holClosingHour")), @AttributeOverride(name = "description", column = @Column(name = "holDescription")), @AttributeOverride(name = "timezone", column = @Column(name = "holTimezone")), @AttributeOverride(name = "day", column = @Column(name = "hol")) })
	private WorkingHours holi = new WorkingHours(DayOfWeek.HOLIDAYS);

	// @Embedded
	// private DeliveryCost defaultDeliveryCost = new DeliveryCost();
	@Expose
	private String url;
	@Expose
	@OneToOne(optional = false, cascade = CascadeType.ALL)
	private UserBean user;

	@Expose
	private String warning;
	@Expose
	private Timestamp warningDate;

	public void addPlate(Plate plate) {
		this.plates.add(plate);
	}

	@Override
	public boolean equals(Object o) {
		if (o instanceof Restaurant) {
			if (((Restaurant) o).getId().equals(this.getId())) {
				return true;
			}
		}
		return false;
	}

	/** 
	 */
	public Key getAddress() {
		return this.address;
	}

	public ContactInfo getContact() {
		return contact;
	}

	public String getDescription() {
		return description;
	}

	public WorkingHours getFri() {
		return fri;
	}

	// public DeliveryCost getDefaultDeliveryCost() {
	// return defaultDeliveryCost;
	// }
	//
	// public Set<DeliveryRange> getDeliveryRange() {
	// return deliveryRange;
	// }

	public Key getId() {
		return id;
	}

	// public ContactInfo getEmail() {
	// return email;
	// }

	// // public List<ExceptionWorkingHours> getExceptionWorkingHours() {
	// // return exceptionWorkingHours;
	// }

	public String getImageAlt() {
		return imageAlt;
	}

	public String getImageUrl() {
		return imageUrl;
	}

	public WorkingHours getMon() {
		return mon;
	}

	public String getName() {
		return name;
	}

	public Set<Plate> getPlates() {
		return this.plates;
	}

	public WorkingHours getSat() {
		return sat;
	}

	public WorkingHours getSun() {
		return sun;
	}

	public WorkingHours getThu() {
		return thu;
	}

	// public List<WorkingHours> getWorkinghoursList() {
	// return this.workinghoursList;
	// }

	public WorkingHours getTue() {
		return tue;
	}

	public String getUrl() {
		return url;
	}

	public UserBean getUser() {
		return user;
	}

	public String getWarning() {
		return warning;
	}

	public Timestamp getWarningDate() {
		return warningDate;
	}

	public WorkingHours getWed() {
		return wed;
	}

	/** 
	 */
	public void setAddress(Key address) {
		this.address = address;
	}

	public String getAddressIdStr() {
		return KeyFactory.keyToString(this.address);
	}

	public void setContact(ContactInfo contact) {
		this.contact = contact;
	}

	/** 
	 */
	// public void setContactInfo(ContactInfo email) {
	// this.email = email;
	// }

	// public WorkingHours getWokingOurs(DayOfWeek day) {
	//
	// return wo.get(m.get(day));
	// }

	// public void setDefaultDeliveryCost(DeliveryCost defaultDeliveryCost) {
	// this.defaultDeliveryCost = defaultDeliveryCost;
	// }

	// public void setDeliveryRange(Set<DeliveryRange> deliveryRange) {
	// this.deliveryRange = deliveryRange;
	// }

	public void setDescription(String description) {
		this.description = description;
	}

	public void updateFri(WorkingHours fri) {
		this.fri = fri;
	}

	/** 
	 */
	// public void setEmail(ContactInfo email) {
	// this.email = email;
	// }

	// public void setExceptionWorkingHours(List<ExceptionWorkingHours>
	// exceptionWorkingHours) {
	// this.exceptionWorkingHours = exceptionWorkingHours;
	// }

	public void setId(Key id) {
		this.id = id;
	}

	public void setImageAlt(String imageAlt) {
		this.imageAlt = imageAlt;
	}

	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}

	public void updateMon(WorkingHours mon) {
		this.mon = mon;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void updateSat(WorkingHours sat) {
		this.sat = sat;
	}

	public void updateSun(WorkingHours sun) {
		this.sun = sun;
	}

	public void updateThu(WorkingHours thu) {
		this.thu = thu;
	}

	public void updateTue(WorkingHours tue) {
		this.tue = tue;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public void setUser(UserBean user) {
		this.user = user;
	}

	public void setWarning(String warning) {
		this.warning = warning;
	}

	public void setWarningDate(Timestamp warningDate) {
		this.warningDate = warningDate;
	}

	public void updateWed(WorkingHours wed) {
		this.wed = wed;
	}

	// public void addFoodCategory(FoodCategory fc) {
	// foodCategories2.add(fc.getId());
	// }
	//
	// public void setAddFoodCategory(List<Key> fcl) {
	// foodCategories2.addAll(fcl);
	// }
	// public List<Key> getFoodCategories() {
	// return foodCategories2;
	// }
	// public void setFoodCategories2(List<Key> foodCategories2) {
	// this.foodCategories2 = foodCategories2;
	// }

	public String getFormalName() {
		return formalName;
	}

	public void setFormalName(String formalName) {
		this.formalName = formalName;
	}

	public String getFormalDocumentId() {
		return formalDocumentId;
	}

	public void setFormalDocumentId(String formalDocumentId) {
		this.formalDocumentId = formalDocumentId;
	}

	public String getPersonInChargeName() {
		return personInChargeName;
	}

	public void setPersonInChargeName(String personInChargeName) {
		this.personInChargeName = personInChargeName;
	}

	public void setMon(WorkingHours mon) {
		this.mon = mon;
	}

	public void setTue(WorkingHours tue) {
		this.tue = tue;
	}

	public void setWed(WorkingHours wed) {
		this.wed = wed;
	}

	public void setThu(WorkingHours thu) {
		this.thu = thu;
	}

	public void setFri(WorkingHours fri) {
		this.fri = fri;
	}

	public void setSat(WorkingHours sat) {
		this.sat = sat;
	}

	public void setSun(WorkingHours sun) {
		this.sun = sun;
	}

	public WorkingHours getHoli() {
		return holi;
	}

	public void setHoli(WorkingHours holi) {
		this.holi = holi;
	}

	@Transient
	private boolean openStatusSet = false;

	public void postLoad() {
		updateOpenStatus();
	}

	private static TimeZone defaultTZ = TimeController.getDefaultTimeZone();
	private static Locale brazilLocale = new Locale("pt", "br");
	protected static final Logger log = Logger.getLogger("copacabana.Entities");

	private static final int START = 0;
	private static final int STOP = 1;
	private static final int STARTINTERVAL = 2;
	private static final int STOPINTERVAL = 3;
	private static SimpleDateFormat sdf = new SimpleDateFormat("kk:mm", brazilLocale);

	public WorkingHours getTodaysWO() {
		Calendar now = java.util.Calendar.getInstance(defaultTZ, brazilLocale);
		int dayOfWeek = now.get(Calendar.DAY_OF_WEEK);
		DayOfWeek dow = WorkingHours.calendarDayOfWeekConverter.get(dayOfWeek);
		WorkingHours wo = null;
		switch (dow) {
		case MONDAY:
			wo = mon;
			break;
		case TUESDAY:
			wo = tue;
			break;
		case WEDNESDAY:
			wo = wed;
			break;
		case THURSDAY:
			wo = thu;
			break;
		case FRIDAY:
			wo = fri;
			break;
		case SATURDAY:
			wo = sat;
			break;
		case SUNDAY:
			wo = sun;
			break;
		default:
			log.log(Level.SEVERE, "Cannot get WorkingHours for today. dayOfWeek:" + dayOfWeek + " dow:" + dow);
		}
		return wo;
	}

	@PostLoad
	public void updateOpenStatus() {
		try {
			openStatusSet = true;
			WorkingHours wo = getTodaysWO();

			if (wo == null) {
				return;
			}
			if (Boolean.TRUE.equals(wo.isClosed())) {
				isOpen = false;
				opensToday = false;
				return;
			} else {
				opensToday = true;
			}

			sdf.setTimeZone(defaultTZ);

			Calendar now = java.util.Calendar.getInstance(TimeController.getDefaultTimeZone(), brazilLocale);

			isOpen = wo.isInRange(now);

			this.openingString = getHourStr(wo.getStartingHour(), wo.getStartingMinute());
			this.closingString = getHourStr(wo.getClosingHour(), wo.getClosingMinute());
			if (wo.getHasSecondTurn()) {
				this.hasSecondTurn = true;
				this.secTurnOpeningString = getHourStr(wo.getSecondTurn()[0], wo.getSecondTurn()[1]);
				this.secTurnClosingString = getHourStr(wo.getSecondTurn()[2], wo.getSecondTurn()[3]);
			}

		} catch (Exception e) {
			e.printStackTrace();
			this.openingString = "Fechado";
			this.openStatusSet = false;
			log.log(Level.SEVERE, "Failed to update open status", e);
		}

	}

	private String getHourStr(Integer h, Integer m) {
		String aux = "";
		if (m < 10) {
			aux = "0";
		}
		return h + ":" + aux + m;
	}

	private Calendar convertWOIntoCalendar(WorkingHours wo, int type) {
		Calendar cal = Calendar.getInstance(TimeController.getDefaultTimeZone(), brazilLocale);
		switch (type) {
		case START:
			cal.set(Calendar.HOUR_OF_DAY, wo.getStartingHour());
			cal.set(Calendar.MINUTE, wo.getStartingMinute());
			break;
		case STOP:
			cal.set(Calendar.HOUR_OF_DAY, wo.getClosingHour());
			cal.set(Calendar.MINUTE, wo.getClosingMinute());
			break;

		default:
			break;
		}

		return cal;
	}

	public static void main(String[] args) {
		Calendar openHour = Calendar.getInstance(defaultTZ, brazilLocale);
		Calendar closeHour = Calendar.getInstance(defaultTZ, brazilLocale);
		int woStart = 11;
		int woEnd = 1;
		openHour.set(Calendar.HOUR_OF_DAY, woStart);
		openHour.set(Calendar.MINUTE, 00);
		closeHour.set(Calendar.HOUR_OF_DAY, woEnd);
		closeHour.set(Calendar.MINUTE, 00);
		Calendar now = java.util.Calendar.getInstance(defaultTZ, brazilLocale);
		if (woEnd < woStart) {
			closeHour.add(Calendar.DAY_OF_YEAR, 1);
		}
		System.out.println("Open : " + openHour.getTime());
		System.out.println("Close: " + closeHour.getTime());
		System.out.println("Now  : " + now.getTime());
		System.out.println(openHour.getTime().before(now.getTime()) && closeHour.getTime().after(now.getTime()));
	}

	public void setOpen(boolean isOpen) {
		this.isOpen = isOpen;
	}

	public boolean isOpen() {
		if (!openStatusSet) {
			updateOpenStatus();
		}
		return isOpen;
	}

	public Set<String> getAcceptablePayments() {
		return acceptablePayments;
	}

	public void setAcceptablePayments(Set<String> acceptablePayments) {
		this.acceptablePayments = acceptablePayments;
	}

	public String getClosingString() {
		return closingString;
	}

	public void setClosingString(String closingString) {
		this.closingString = closingString;
	}

	public String getOpeningString() {
		return openingString;
	}

	public void setOpeningString(String openingString) {
		this.openingString = openingString;
	}

	public void addDeliveryRange(DeliveryRange del) {
		if (deliveryRanges == null) {
			deliveryRanges = new HashSet<DeliveryRange>();
		}
		deliveryRanges.add(del);
	}

	public Set<DeliveryRange> getDeliveryRanges() {
		return deliveryRanges;
	}

	public void setDeliveryRanges(Set<DeliveryRange> deliveryRanges) {
		this.deliveryRanges = deliveryRanges;
	}

	public void removeDeliveryRange(DeliveryRange toDelelete) {
		this.deliveryRanges.remove(toDelelete);

	}

	public String getImgKeyString() {
		return imgKeyString;
	}

	public void setImgKeyString(String imgKeyString) {
		this.imgKeyString = imgKeyString;
	}

	public void removePlate(Plate p) {
		this.plates.remove(p);

	}

	public Boolean getOnlyForRetrieval() {
		return onlyForRetrieval;
	}

	public void setOnlyForRetrieval(Boolean allowGetInPlace) {
		this.onlyForRetrieval = allowGetInPlace;
	}

	public String getUniqueUrlName() {
		return uniqueUrlName;
	}

	public void setUniqueUrlName(String uniqueUrlName) {
		this.uniqueUrlName = uniqueUrlName;
	}

	public SiteStatus getSiteStatus() {
		return siteStatus;
	}

	public void setSiteStatus(SiteStatus siteStatus) {
		this.siteStatus = siteStatus;
	}

	public Date getLastAcceptedTermsDate() {
		return lastAcceptedTermsDate;
	}

	public void setLastAcceptedTermsDate(Date lastAcceptedTermsDate) {
		this.lastAcceptedTermsDate = lastAcceptedTermsDate;
	}

	public String getCurrentDelay() {
		return currentDelay;
	}

	public void setCurrentDelay(String currentDelay) {
		this.currentDelay = currentDelay;
	}

	public FractionPriceType getFractionPriceType() {
		return fractionPriceType;
	}

	public void setFractionPriceType(FractionPriceType fractionPriceType) {
		this.fractionPriceType = fractionPriceType;
	}

	public Boolean getHasSecondTurn() {
		return hasSecondTurn;
	}

	public void setHasSecondTurn(Boolean hasSecondTurn) {
		this.hasSecondTurn = hasSecondTurn;
	}

	public String getSecTurnClosingString() {
		return secTurnClosingString;
	}

	public void setSecTurnClosingString(String secTurnClosingString) {
		this.secTurnClosingString = secTurnClosingString;
	}

	public String getSecTurnOpeningString() {
		return secTurnOpeningString;
	}

	public void setSecTurnOpeningString(String secTurnOpeningString) {
		this.secTurnOpeningString = secTurnOpeningString;
	}

	public boolean isOpensToday() {
		return opensToday;
	}

	public void setOpensToday(boolean opensToday) {
		this.opensToday = opensToday;
	}

	public String getIdStr() {
		return KeyFactory.keyToString(this.getId());
	}

	public String getDirectAccessUrl() {
		if (this.getUniqueUrlName() != null && this.getUniqueUrlName().length() > 0) {
			return "/" + this.getUniqueUrlName();
		} else {
			return "/?showRestaurant=true&restaurantId=" + this.getIdStr();
		}
	}

}
