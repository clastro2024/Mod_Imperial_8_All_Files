Fun
{
  // *** UTILIDADES ***
  void     Print                               (... );
  bool     GetAsyncKeyState                    (string szVKey);
  // Triggers
  bool     ActivarTrigger                      (string   szTrigger);
  bool     DesactivarTrigger                   (string   szTrigger);
  bool     DestruirTrigger                     (string   szTrigger);
  // Timers
  handle   CrearTimer                          (float    numMs);
  bool     Wait                                (handle   hHandle);
  bool     WaitBool                            (bool expr);
  // Handles
  handle   CrearHandle                         (string szNombre, ...);
  void     DisposeHandle                       (handle*  phHandle);
  handle   CrearSemaforo                       (void);
  bool     HandleDisparado                     (handle hHandle);
  bool     HandleInicializado                  (handle hHandle);

  
  // *** CIVILIZACIONES ***
  handle   CrearCivilizacion                   (string szNombre, string szRaza, float color, string szTipo); 
  handle   DarCivilizacion                     (string szNombre);
  void     NeutralizarCivilizacion             (string szNombre, bool bValor);
  void     CambiarBando                        (string szCiviSrc, string szCiviDst);  
  void     CambiarBandoPorGrupo                (string szNombreGrupo, string szCiviDst);  
  void     CambiarBandoEstructura              (string szNombreEA, string szCivDest);
  void     CambiarBandoFortaleza               (string szNombreFort, string szCivDest);
  bool     CivilizacionEstaKO                  (string szNombreCivi);
  // Aviso
  void     AvisoCivilizacion                   (string szNombre, float vx, float vy);
  // Alianzas
  bool     EstanAliadas                        (string szCiv1, string szCiv2);
  void 	   RomperAlianzaPorNombre				       (string civiA, string civiB);
  void 	   CrearAlianzaPorNombre				       (string civiA, string civiB);
  // Unidades
  float    DarUnidadesMatadas                  (string szNombreCivi);
  float    DarUnidadesMuertas                  (string szNombreCivi);
  float    DarUnidadesVivas                    (string szNombreCivi);
  float    DarPotenciaCivilizacion             (string szNombreCivi);
  // Zonas   
  bool     HaEntradoCivilizacion               (handle hZona, float fMask);
  bool     HaEntradoCivilizacionPorNombre      (string szNombreZona, float fMask);
  bool     HanEntradoCivilizacionesEnZona      (string szZonaName, string szCiviName, ...);
  bool     HaSalidoCivilizacion                (handle hZona, float fMask);
  float    DarPorcentajeTropasEnZona           (string szCiviName, string szZonaName);
  float    DarNumUnidadesEnZona                (string szCiviName, string szZonaName);
  // Tropas
  bool     AnyadirGrupoTropasACivilizacion     (string szGrupoNombre, string szNombreCivi);
  void     MaxTropasCiv                        (string szNombreCivilizacion, float fMaxNumTropas);

  bool     EstaPuebloConquistado               (string szNombreCivilizacion, string szNombrePueblo);
  void     CivilizacionSetMantenerPosicion     (string szNombreCivi, bool bSet);  
  float    DarTropasVivasDeGrupo               (string szGrupoNombre);
  float    DarTropasVivasGrupoYTipo            (string szGrupoNombre, string szDefUnidad);
  float    DarTropasMuertasDeGrupo             (string szGrupoNombre);
  bool     VisibleTropaDeOtraCiv               (string szMiCivilizacion, string szLaOtraCivilizacion, ...); // Admite un booleano para indicar si la vision es HARD o no
  bool     ReclutarTropasVisibles              (string szMiCivilizacion, string szLaOtraCivilizacion, ...); // Admite un booleano para indicar si la vision es HARD o no
  
  void     TodosAlAtaque                       (string szNombreCivilizacion);
  void     DarExpCiv                           (float fExp, string szNombreCiv); 
  void     DarExpCenturion                     (float fExp, string szNombreCenturion); 
  void     DarPHCiv                            (float fExp, string szNombreCiv); 
  float    DarVidaGrupo                        (string szNombreGrupo);
  void     QuitarEfectosHabilidades            (string szGrupoTropas);
  void     ActivarInferioridad                 (bool bActivar);
  void     PonerSecuenciaEnte                  (string szEnte, string szAnimacion);
  void     PonerGeometriaEnte                  (string szEnte, string szGeometria);


  // *** ESTRATEGIAS ***
  handle   CrearEstrategiaScript               (void); // Puede llevar un string con el nombre del fichero de actitud
  handle   CrearEstrategiaEscaramuza           (void); // Puede llevar un string con el nombre del fichero de actitud
//  handle   CrearEstrategiaPlayer               (void);
  bool     AsignarEstrategia                   (handle hCivilizacion, handle hEstrategia);
  void     StartEstrategia                     (handle hEstrategia);
  // Actitud IA
  void     SetValue                            (handle hEstrategia, string szNombre, ...);
  void     ResetGruposTropasAEntrenar          (handle hEstrategia);
  // Developers only
  handle   CrearEstrategiaSergio               (void);
  handle   CrearEstrategiaGarrofi              (void);
  handle   CrearEstrategiaGaltza               (void);
  // Obsoleto
  handle   CrearEstrategiaDefensiva            (void);
  handle   CrearEstrategia                     (string szNombre); //Crear Estrategia soporta: "Prueba"
  void     LanzarAtaqueDebil                   (handle hEstrategia, handle hZonaAtaque);
  void     LanzarAtaque                        (handle hEstrategia, handle hZona, string szTipoGrupo, string szTipoAtaque);
  void     SetParamEstrategia                  (handle hEstrategia, string szNombreParam, ...);

   
  // *** OBJETIVOS ***
  handle   CrearObjetivo                       (handle hEstrategia, string szTipoObjetivo, ...); // Soporta: "ConquistaPueblo2", "AsaltarCampamento", "DefensaSemiCoordinada"
  bool     AnyadirObjetivo                     (handle hEstrategia, handle hObjetivo);
  bool     AnyadirTropaAObjetivo               (handle hObjetivo, string szTropa, ...);
  bool     AnyadirGrupoAObjetivo               (handle hObjetivo, string szGrupo, ...);
  bool     AnyadirTropasCivilizacionAObjetivo  (handle hObjetivo, string szNombre, ...);
  void     CambiarObjetivo                     (handle hObjetivo, string szTipoObjetivo, ...);
  // Params
  void     SetParamObjetivo                    (handle hObjetivo, string szNombreParam, ...);
  bool     ObjetivoGetParamBOOL                (handle hObjetivo, string szNombreParam);
  float    ObjetivoGetParamFLOAT               (handle hObjetivo, string szNombreParam);
  handle   ObjetivoGetParamHANDLE              (handle hObjetivo, string szNombreParam);
  // Para Planificador
  void     EjecutarPlanificador                (handle hEstrEscaramuza, bool bEjecutar);
  bool     ProhibirObjetivo                    (handle hEstrategia, string szTipoObjetivo, bool bProhibir);
  void     DarObjetivo2CPU                     (handle hObjetivo, bool bDar);
  // Freaks only
  handle   HuirAPuebloAliadoMasCercano         (handle hObjetivo, float x_Reserva, float y_Reserva);
  void     HacerVisibleTropasObjetivo          (handle hObjetivo, bool bVisible, ...); // Acepta una lista de cadenas con nombres de tropas


  
  // *** TACTICAS ***
  handle   CrearTactica                        (handle hEstrategia, string szTipoTactica,...); // Soporta: "PatrullarGrupo", "MantenerPosicion", "CazaYCaptura", "AtacarPunto"
  bool     AnyadirTactica                      (handle hEstrategia, handle hTactica);   
  bool     AnyadirTropaATactica                (handle hTactica, string szTropaName, ...);   // Ver doc para par�metros extra
  bool     AnyadirGrupoATactica                (handle hTactica, string szNombreGrupo, ...);
  bool     AnyadirTropasCivilizacionATactica   (handle hTactica, handle hCivilizacion);
  // Params
  bool     TacticaGetParamBOOL                 (handle hTactica, string szNombreParam);
  void     SetParamTactica                     (handle hTactica, string szNombreParam, ...);


  // *** TROPAS ***
  bool     GrupoSiendoAtacado                  (string szNombreGrupo);
  bool     TropaHaRecibidoDanyo                (handle hBuffer);
  void     InitBufferVidaTropa                 (handle hHandleBuffer, string szNombreTropa);
  bool     EstaTropaViva                       (string szNombreTropa);
  bool     TropaRecibeDanyo                    (string szNombreTropa);
  void     SetMoverFisicoTropa                 (string szNombreTropa, bool bActivar);
  void     SetMoverFisicoGrupoTropas           (string szNombreGrupoTropas, bool bActivar);   
  void     InitBufferIdUnidad                  (handle hHandleBuffer, string szNombreTropa);
  bool     EstaUnidadViva                      (handle hBuffer);
  bool     TropaEstaEnCivilizacion             (string szNombreTropa, string szNombreCivi);
  void     AparicionMagicaDeTropaEnPueblo      (handle hCivilizacion, string szPueblo, string szNombre, string szTipo, string szFormacion, float fUnidades, ...); // Param. opcional: string szGrupoIntroducir
  
  void     SetHabilidadAutomatica              (string szNombreTropa, string szNombreHabilidad, bool bOn); // Para ver el nombre de la habilidad, acudir al .dat donde se definen los params de la tropa
  
  void     TropaIrAPunto                       (string szTropaName, float posX, float posY);
  void     TropaActivarIA                      (string szTropaName, bool bActivar);

  void     TropaSigueRutaPredefinida                     (string szTropaName, string szRutaNombre);
  void     GrupoTropasSeguirRutaPredefinida						   (string szNombreGrupo, string szNombreRuta);
  void     TropaAbortaRutaPredefinida                    (string szTropaName);
  // Esto se ha quitado porque a) No se usa y b) No funciona muy alla
  //  void     TropaMueveAPuntoPorRutaPredefinida_Conjunto   (string szTropaName, float fPosX, float fPosY, ...);
  //  void     TropaMueveAPuntoPorRutaPredefinida_Distancia  (string szTropaName, float fPosX, float fPosY, float fRadioTestRuta);
  void     InteractuarTropaConEnte                       (string szNombreTropa, string szNombreEnte);
  void     AtacarEnemigosEnZona                          (string szNombreGrupo, string szNombreZona);
  bool     HayEnemigosEnRadioVision                      (string szNombreTropa);
  bool     HayEnemigosEnRadioVisionALaredonda            (string szNombreTropa, float fRadio);
  bool     HaRecibidoAvisoAtaque                         (string szNombreTropa);
  void     SetActitudAgresiva                            (string szNombreTropa, bool bOn);
  void     SetActitudAgresivaGrupo                       (string szNombreGrupo, bool bOn);
  void     ConstruirGuarnicion                           (string szTropa, string szPueblo);
  bool     HaEntradoTropaEnZona                (string szNombreZona, string szNombreTropa);
  
  bool     ReclutarTropasCerca                 (string szNombreTropa, string szCivilizacionReclutada, float fRadio);
  
  
  // *** ENTES ***
  bool     EstaEnteVivo                        (string szNombreEnte);
  void     DestruirEnte                        (string szNombreEnte);


  // *** ZONAS ***
  handle   CrearZonaRectangular                (float vx, float vy, float tamx, float tamy);
  handle   CrearZonaEliptica                   (float vx, float vy, float radiox, float radioy);
  handle   CrearZonaPoligonal                  (... );
  handle   DarZonaPorNombre                    (string szNombre);  
  bool     EstaUnidadEnZona                    (handle hBuffer, string szNombreZona);
  bool     HayTipoUnidadEnZona                 (string szTipoUnidad, string szNombreZona);


  // *** INTERFACE ***
  void     BloquearInterfaz                    (bool bBloquear);
  void     OcultarInterfaz                     (bool bOcultar);
  void     ActivarCinemascope                  (bool bActivar);
  void     ActivarPresentacion                 (bool bActivar, string szNumeroTitulo , string szLugarFecha, handle hFin );
  void     PararLogica                         (bool bActivar);
  
  
  // ****** PETICIONES TROPAS ****
  float    CrearPeticionTropa                  (handle hEstrategia, handle hObjetivo, ...);
  bool     IntroducirTropaAPeticion            (handle hEstrategia, float idPeticion, string szTipoTropa, float fPotencia);
  void     IntroducirTipoAPeticion             (handle hEstrategia, float idPeticion, string szDefTipo, float fPotencia);
  void     SetPeticionRecursiva                (handle hEstrategia, float idPeticion, bool bSet);
  
  void     SetDelayEntrenamientoTropasPueblo   (handle hEstrategia, string szNombrePueblo, float fDelay); // Delay en milisegundos
  void     SetDelayEntrenamientoTropasPueblo_DOS(handle hEstrategia, string szNombrePueblo, float fDelay); // Delay en milisegundos
  void     SetEntrenamientoPueblo              (handle hEstrategia, string szNombrePueblo, bool bEntrena);
  void     SetGeneracionAutomatica             (handle hEstrategia, string szNombrePueblo, bool bAutomatica);
  void     SetObjetivoTropasGeneradas          (handle hEstrategia, string szNombrePueblo, handle hObjetivo);
  

  // ****** CINEMATICAS ****
  void      IniciarCargaCinematica            (string szNombreFile);
  void      TocarCinematica                   (string szNombreFile);
  void      DestruirCinematica                (string szNombreFile);  
  bool      IsCinematicaReady                 (string szNombreFile);


  // Misc
  void	   MirarLibrePosDireccion              (float  fPosX, float fPosY, float fPosZ, float fDirX, float fDirY, float fDirZ);
  void	   MirarLibrePosOrientacion            (float  fPosX, float fPosY, float fPosZ, float fOX,   float fOY,   float fOZ);
  void     MirarLibrePosPunto                  (float  fPosX, float fPosY, float fPosZ, float fDestX, float fDestY, float fDestZ);
  void     MirarAPunto                         (float  fPosX, float fPosY);
  void     PonerCamaraModoJuego                (void);
  void     IluminarZona                        (float  fPosX, float fPosY, float fPosZ, float fRadio, float fTiempo);
  void     IluminarZonaOnOff                   (float  fPosX, float fPosY, float fPosZ, float fRadio, string szNombreZona, bool bOn );
  void     HacerVisibleTropa                   (string szNombreTropa, bool bValor );
  void     HacerVisibleGrupoTropas             (string szNombreGrupoTropas, bool bValor );
  void     HacerVisibleCivilizacion            (string szNombreCivilizacion, bool bValor );
  void     LiberarUnidad                       (string szNombreUnidad, string szDefUnidadFinal, string szNombreCiv );
  void     PonerColorMinimapaTropa             (string szNombreTropa, float fColor, bool bValor );
  void     PonerColorMinimapaGrupo             (string szNombreGrupo, float fColor, bool bValor );
  void     DarPosicionCamara                   (float*  fPosX, float* fPosY);
  void     IntroducirPonerModoJuegoCamara      (bool bPoner);
  void     IntroducirTrayectoriaCamara         (... );
  void     IntroducirPuntoMiraCamara           ( float fX, float fY, float fZ, float fTiempo );
  void     IntroducirPuntoPosCamara            ( float fX, float fY, float fZ, float fTiempo );
  void     PonerDuenyoFortaleza                (string szFortaleza, string szCivilizacion );
  void     CrearSplinesCamara                  (void);
  void     EncolaTrayectoriaCamara             (string szTrayectoria, bool bPosInicial, bool bPosFinal, float fTiempoInicial, float fTiempoFinal );
  void     EncolarPausaCamara                  (float fMiliSegundos);
  void     EncolarMirarEnteCamara              (string szNombreEnte);
  void     EncolarColocarYMirarPunto           (string szColocacionCamara);
  void     EncolarTrayectoriaMirarEnteCamara   (string szNombreEnte, bool bInicio, bool bFin, float fTiempoInicio, float fTiempoFin );
  void     IntroducirPuntoSincronia            (void);
  void     IntroducirLocucion                  (string szIdSonido, string szSubtitulos, float fTiempo, float fAncho, float fAlto );
  void     PonerHandleInterrupcion             ( handle hHandle );
  void     PonerHandleEsperaSincronizacion     ( handle hHandle );
  void     VaciarOrdenesCamara                 (void);
  void     VaciarLocuciones                    (void);
  void     EjecutarOrdenesCamara               (void);
  void     LanzarSonido                        (string szIdSonido);
  void     PonerVidaEnte                       (string szNombre, float fVida);
  void     BloquearComportamientos             (bool   bBloquear);
  void     PonerFuegoEnte                      (string szEnte, float fFuego);
  bool     HayAlgunaEstructuraIncendiandose    (string szNombreTipoEstructura);   
  void     MensajeChat                         (...);
  void     MensajeChatJuego                    (string szCadenaTraducible);
  void     MensajeLocucionado                  (string szFileSound, string szCadenaTraducible);
  float    DarTiempoTranscurrido               (void);
  bool     EstructuraDestruida                 (string szNombreEstructura);
  void     VisualizarTropaMiniMapa             (string szNombreTropa, bool bValor);
  void     VisualizarGrupoMiniMapa             (string szNombreGrupo, bool bOn);
  float    DarNumeroAleatorio                  (float x0, float x1);
  bool     EstaCivilizacionCurada              (string szNombreCivilizacion);
  bool     EsEstructuraAtacada                 (string szEstructura, string szCiv);
  void     AtacarEnte                          (string szAtacante, string szAtacado);
  void     FinalizarMision                     (bool bSuccess);
  void     CrearTropa                          (string szCivilizacion, string szTipoTropa, float fNumUnidades, float fPosX, float fPosZ, float fOrientacion, ... ); // opcional nombre y grupo (string)
  
  // Formato: lista de nombres de civilizacion, lista de nombres de pueblo, bool bValenConquistados, bool bValenDestruidos
  // Como minimo necesita un nombre de civilizacion y otro de pueblo. Por defecto valen tanto conquistados como destruidos
  float    DarNumPueblosConqDestr              (string szString1, string szString2, ...); // Varios nombres de pueblos
  
  bool     EstaConstruyendoPuente              (string szCivName, ...);
  bool     EstaPuenteConstruido                (string szNombrePuente, ...); // Opcional: nombre de una civilizacion
  float    DarDificultadMision                 (void);
  void     OrdenarTropaMantenerPosicion        (string szNombreEnte, bool bOn);

// ******* TUTORIALES ****
  void	   CrearPanelTutorial				           ( handle hHandleSkip, handle hHandleNext );
  void	   DestruirPanelTutorial			         (void);
  void     OcultarPanelTutorial                ( bool bOcultar );
  void	   IntroducirPasoTutorial              ( string szTexto, string szObjetivo );
  void     AvanzarPasoTutorial                 ( float fPaso );
  void	   IntroducirTip                       ( string szTexto, string szObjetivo );
  void     SeleccionarTip                      ( float fPaso );
  void     ActivarHandleBool                   ( handle Handle );
  void     DesactivarHandleBool                ( handle Handle );
  void     QuitarVigilanciaHandleBool          ( handle Handle );
  void     PonerHandleBoolACamara              ( handle Handle );
  void     VigilarOrdenConstruirGuarnicion     ( string* pszNombre, string* pszDefUnidad, handle Handle );
  void     VigilarOrdenMover                   ( string* pszNombre, string* pszDefUnidad, handle Handle );
  void     VigilarOrdenMoverActitud            ( string* pszNombre, string* pszDefUnidad, handle Handle );
  void     VigilarOrdenMoverOrientar           ( string* pszNombre, string* pszDefUnidad, handle Handle );
  void     VigilarOrdenAtacar                  ( string* pszNombre, string* pszDefUnidad, handle Handle );
  void     VigilarOrdenOrientar                ( string* pszNombre, string* pszDefUnidad, handle Handle );
  void     VigilarOrdenTransformarALigera      ( string* pszNombre, string* pszDefUnidad, handle Handle );
  void     VigilarOrdenTransformarACenturion   ( string* pszNombre, string* pszDefUnidad, handle Handle );
  void     VigilarOrdenHoldPosition            ( string* pszNombre, string* pszDefUnidad, handle Handle );
  void     VigilarOrdenActitudDefensiva        ( string* pszNombre, string* pszDefUnidad, handle Handle );
  void     VigilarOrdenActitudOfensiva         ( string* pszNombre, string* pszDefUnidad, handle Handle );
  void     VigilarOrdenProtegerZona            ( string* pszNombre, string* pszDefUnidad, handle Handle );
  void     VigilarOrdenProtegerTropa           ( string* pszNombre, string* pszDefUnidad, handle Handle );
  void     VigilarOrdenUnir                    ( string* pszNombre, string* pszDefUnidad, handle Handle );
  void     VigilarOrdenDistribuir              ( string* pszNombre, string* pszDefUnidad, handle Handle );
  void     VigilarOrdenRomper                  ( string* pszNombre, string* pszDefUnidad, handle Handle );
  void     VigilarOrdenCorrer                  ( string* pszNombre, string* pszDefUnidad, handle Handle );
  void     VigilarOrdenHabilidadEspecial       ( string* pszNombre, string* pszDefHabilidad, handle Handle );
  void     VigilarOrdenCurarTropa              ( string* pszNombre, string* pszDefUnidad, handle Handle );
  void     VigilarInterfazSeleccion            ( string* pszNombre, string* pszDefUnidad, handle Handle );
  void     VigilarInterfazCajaSeleccion        ( string* pszNombre, string* pszDefUnidad, handle Handle );
  void     VigilarSeleccionarGrupo             ( string* pszNombre, string* pszDefUnidad, handle Handle );
  void     VigilarCrearGrupo                   ( string* pszNombre, string* pszDefUnidad, handle Handle );
  void     VigilarConstruccionAcabada          ( string* pszNombre, string* pszDefEstructura, handle Handle );
  void     VigilarConstruccionMaquinaAcabada   ( string* pszNombre, string* pszDefUnidad, handle Handle );
  void     VigilarEntrenamientoAcabado         ( string* pszNombre, string* pszDefUnidad, handle Handle );
  void     IntroducirRestriccionUnidad         ( string pszOrden, string pszDefUnidad, string pszCivilizacion );
  void     IntroducirRestriccionEstructura     ( string pszOrden, string pszDefEstructura, string pszCivilizacion );
  void     IntroducirRestriccionHabilidad      ( string pszOrden, string pszDefHabilidad, string pszCivilizacion );
  void     QuitarRestriccionUnidad             ( string pszOrden, string pszDefUnidad, string pszCivilizacion );
  void     QuitarRestriccionEstructura         ( string pszOrden, string pszDefEstructura, string pszCivilizacion );
  void     QuitarRestriccionHabilidad          ( string pszOrden, string pszDefHabilidad, string pszCivilizacion );
  
  float    DarCantidadLluvia                   (void);
  void     ModificarLluvia                     (float fCantidadLluvia, float fCantidadRelampagos, float fVelocidadTransicion, float fDuracionSegundos);
  void     LanzarRelampago                     (void);  

  // *** OBJETIVOS DE LA MISION ***
  void     AgregarObjetivoMision               (handle Handle,string pszNombre);
  bool     HayObjetivosPendientes              (void);
  void     EliminarObjetivoMision              (handle Handle);
  void     IndicarObjetivoCumplido             (handle Handle);
  void     IndicarObjetivoPendiente            (handle Handle);
  void     IndicarObjetivoFracasado            (handle Handle);
  void     ObjetivosMisionCambiados            (void);

  // *** SUBTITULOS ***
  void     PonerSubtitulo                      (string pszNombre,float fCajaX,float fCajaY);
  bool     QuitarSubtitulo                     (void);

}