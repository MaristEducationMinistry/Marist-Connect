@import <Foundation/Foundation.j>

var MCSharedDataCentre = nil;

@implementation MCSharedData : CPObject
{
	id _user;
	CPArray _personTypes;
	CPArray _courseTypes;
	CPDictionary _genderTypes;
	CPDictionary _cities;
	CPDictionary _countries;
	CPDictionary _tShirts;
	id _class;
	
	int _finished;
	id _target;
}

//target
- (void)setTarget:(id)target
{
	_target = target;
}

//commom instance return
+ (MCSharedData)sharedCentre
{
	if (!MCSharedDataCentre) {
		MCSharedDataCentre = [[MCSharedData alloc] init];
	}
	
	return MCSharedDataCentre;
}

//gathering of all data
- (void)gatherSharedData
{
	_finished = 0;
	
	//get updated user
	_user = Parse.User.current();
	
	//person or inst
	if (_user.get("classType") == "Person") {
		
	} else {
		var inst = Parse.Object.extend("Institution");
		var instQuery = new Parse.Query(inst);
		instQuery.equalTo("objectId", _user.get("classID"));
		instQuery.first({
			success: function(object) {
				_class = object;
				[self checkAllData];
			}
		});
	}
	
	//get genders
	var genders = Parse.Object.extend("Gender");
	var genderQuery = new Parse.Query(genders);
	genderQuery.find( {
		success: function(results) {
			_genderTypes = [[CPDictionary alloc] init];
			for (var i=0;i<results.length;i++) 
			{
				[_genderTypes setValue:results[i] forKey:results[i].get("genderType")];
			}
			[self checkAllData];
		}
	});
	
	//get cities
	var cities = Parse.Object.extend("City");
	var citiesQuery = new Parse.Query(cities);
	citiesQuery.find( {
		success: function(results) {
			_cities = [[CPDictionary alloc] init];
			for (var i=0;i<results.length;i++) 
			{
				[_cities setValue:results[i] forKey:results[i].get("cityName")];
			}
			[self checkAllData];
		}
	});
	
	//get countries
	var countries = Parse.Object.extend("Country");
	var countriesQuery = new Parse.Query(countries);
	countriesQuery.find( {
		success: function(results) {
			_countries = [[CPDictionary alloc] init];
			for (var i=0;i<results.length;i++) 
			{
				[_countries setValue:results[i] forKey:results[i].get("countryName")];
			}
			[self checkAllData];
		}
	});
	
	//get peronTypes
	var personTypes = Parse.Object.extend("PersonType");
	var personTypesQuery = new Parse.Query(personTypes);
	personTypesQuery.ascending("typeName");
	personTypesQuery.find( {
		success: function(results) {
			_personTypes = [CPArray arrayWithArray:results];
			[self checkAllData];
		}
	});
	
	//get course types
	var courseTypes = Parse.Object.extend("CourseType");
	var courseTypesQuery = new Parse.Query(personTypes);
	courseTypesQuery.ascending("typeName");
	courseTypesQuery.find( {
		success: function(results) {
			_courseTypes = [CPArray arrayWithArray:results];
			[self checkAllData];
		}
	});
	
	//tshirts
	var tshirts = Parse.Object.extend("TShirt");
	var tshirtsQuery = new Parse.Query(tshirts);
	tshirtsQuery.find( {
		success: function(results) {
			_tshirts = [[CPDictionary alloc] init];
			for (var i=0;i<results.length;i++) 
			{
				[_tshirts setValue:results[i] forKey:results[i].get("genderSpecific")];
			}
			[self checkAllData];
		}
	});
}

//method to check all data is collected before calling to delegate
- (void)checkAllData
{
	_finished++;
	if (_finished == 7) {
		[_target dataIsCollected];
	}
}

//getters
- (id)user
{
	return _user;
}

- (id)pClass
{
	return _class;
}

- (CPArray)personTypes
{
	return _personTypes;
}

- (CPArray)courseTypes
{
	return _courseTypes;
}

- (CPDictionary)genderTypes
{
	return _genderTypes;
}

- (CPDictionary)cities
{
	return _cities;
}

- (CPDictionary)countries
{
	return _countries;
}

- (CPDictionary)tshirtsQuery
{
	return _tShirts;
}

@end