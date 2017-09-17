Функция СоздатьОбновитьДокументПрочиеЗатраты(стрПараметры) Экспорт 
	ДокументОбъект = Документы.ПрочиеЗатраты.СоздатьДокумент();
	ДокументОбъект.Дата = ТекущаяДата();
	ДокументОбъект.Сотрудник = стрПараметры.Сотрудник;//ПараметрыСеанса.ТекущийПользователь.Сотрудник;
	ДокументОбъект.Проект = стрПараметры.Проект;
	ДокументОбъект.Согласовано = Ложь;
	ДокументОбъект.Комментарий = стрПараметры.Комментарий;
	//ДокументОбъект.ТСД = ссылкаТСД; 
	
	НовыйТовар = ДокументОбъект.Товары.Добавить();
	НовыйТовар.Наименование = стрПараметры.НаименованиеЗатраты;
	НовыйТовар.Количество = 1;
	НовыйТовар.Цена = стрПараметры.Сумма;
	НовыйТовар.Сумма = стрПараметры.Сумма;
	НовыйТовар.НаКомпенсацию = Истина;

	ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
	Возврат ДокументОбъект.Ссылка;
КонецФункции
