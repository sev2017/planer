
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	//Статус =  Перечисления.СтатусыПроектов.ВРаботе;
	//Куратор = ОбщегоНазначенияПовтИсп.ПолучитьТекущегоСотрудника();
	//Ответственный = Куратор;
	//Организация = ДанныеЗаполнения.Организация;
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.СчетПокупателя") Тогда
		Контрагент = ДанныеЗаполнения.Контрагент;
	КонецЕсли;
	
КонецПроцедуры
