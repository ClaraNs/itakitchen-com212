import { Component, ElementRef, ViewChild } from '@angular/core';
import { IonicPage, NavController, NavParams } from 'ionic-angular';
import Chart from 'chart.js';
import { ShareService } from '../share/share';

/**
 * Generated class for the RelatoriosPage page.
 *
 * See https://ionicframework.com/docs/components/#navigation for more info on
 * Ionic pages and navigation.
 */

@IonicPage()
@Component({
  selector: 'page-relatorios',
  templateUrl: 'relatorios.html',
})
export class RelatoriosPage {
  @ViewChild('barCanvasUsuario') barCanvaUsuario: ElementRef;
  @ViewChild('barCanvasEstab') barCanvaEstab: ElementRef;
  barChartEstab: any;
  barChartUsuario: any;
  usuarios: any = [];
  estabs: any = [];

  constructor(public navCtrl: NavController, public navParams: NavParams, private share: ShareService) {
  }

  ionViewDidLoad() {

    this.share.retornaEstabMaisBemAvaliados().subscribe((data: any) => {
      let labels = [];
      let valores = [];
      data.forEach(x => {
        labels.push(x[0]);
        valores.push(x[1]);
        let estab = {
          nome: x[0],
          media: x[1]
        };
        this.estabs.push(estab);
      });
      this.barChartEstab = new Chart(this.barCanvaEstab.nativeElement, {
        type: 'bar',
        data: {
          labels: labels,
          datasets: [{
            label: 'Média de avaliações',
            data: valores,
            backgroundColor: 'rgba(50, 19, 19, 0.5)',
            borderColor: 'rgba(50, 19, 19, 1)',
            borderWidth: 1
          },
          ]
        },
        options: {
          responsive: true,
          scales: {
            yAxes: [{
              ticks: {
                stepSize: 0.5,
                beginAtZero: true
              }
            }]
          }
        }
      });
    });


    this.share.retornaUsuarioMaisAvaliador().subscribe((data: any) => {
      let labels = [];
      let valores = [];
      data.forEach(x => {
        labels.push(x[0]);
        valores.push(x[1]);
        let user = {
          nome: x[0],
          qtd: x[1]
        };

        this.usuarios.push(user);
      });
      this.barChartUsuario = new Chart(this.barCanvaUsuario.nativeElement, {
        type: 'bar',
        data: {
          labels: labels,
          datasets: [
            {
              label: 'Número de avaliações',
              data: valores,
              backgroundColor: 'rgba(244, 153, 26, 0.5)',
              borderColor: 'rgba(244, 153, 26, 1)',
              borderWidth: 1
            }]
        },
        options: {
          responsive: true,
          scales: {
            yAxes: [{
              ticks: {
                stepSize: 1,
                beginAtZero: true
              }
            }]
          }
        }
      });
    });

  }
}
